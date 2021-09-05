function [base_freq_record, component_record] = get_component(wave_path)

    [x, Fs] = audioread(wave_path);
    
    x = mean(x, 2);
    max_Fs = 12000;
    if Fs > max_Fs
        x = resample(x, max_Fs, Fs);
        Fs = max_Fs;
    end
    clear max_Fs;

    % Split music

    disp('Begin to split music...');
    disp('    Processing music...');
    h_wait_bar = waitbar(0, 'Processing music...');

    y1 = abs(x);
    y2WndLen = round(Fs / 10);
    y2 = conv(y1, hanning(y2WndLen));
    y2 = y2(round(y2WndLen/2):end);
    y3 = diff(y2);
    y4 = max(y3, 0);
    y5WndLen = round(Fs / 8);
    y5 = conv(y4, hanning(y5WndLen));
    y5 = y5(round(y5WndLen/2):end);

    figure(1);
    subplot(6, 1, 1);
    plot([0:length(x)-1] / Fs, x);
    title('\itx');
    subplot(6, 1, 2);
    plot([0:length(y1)-1] / Fs, y1);
    title('{\ity}_1');
    subplot(6, 1, 3);
    plot([0:length(y2)-1] / Fs, y2);
    title('{\ity}_2');
    subplot(6, 1, 4);
    plot([0:length(y3)-1] / Fs, y3);
    title('{\ity}_3');
    subplot(6, 1, 5);
    plot([0:length(y4)-1] / Fs, y4);
    title('{\ity}_4');
    subplot(6, 1, 6);
    plot([0:length(y5)-1] / Fs, y5);
    title('{\ity}_5');

    clear y1 y2 y3 y4 y2WndLen y5WndLen;
    waitbar(1, h_wait_bar);
    disp('    OK.');
    disp('    Finding split point...');
    waitbar(0, h_wait_bar, 'Finding split point...');

    dy5 = diff(y5);
    is_positive = (dy5(1) > 0);
    primary_find_idx = [];
    for i = 2 : 1 : length(dy5)
        if ((dy5(i) > 0) ~= is_positive)
            is_positive = ~is_positive;
            if is_positive == false
                primary_find_idx = [primary_find_idx; i];
            end
        end
    end
    waitbar(1 / 3, h_wait_bar);

    min_find_len = 3;
    if length(primary_find_idx) < min_find_len * 2
        error('    Error: The music is too short!');
    end

    primary_find_val = y5(primary_find_idx);
    primary_sort_res = sort(primary_find_val, 'descend');
    level = mean(primary_sort_res(1:min_find_len)) ./ 20;
    secondary_find_idx = primary_find_idx(y5(primary_find_idx) >= level);
    
    waitbar(2 / 3, h_wait_bar);

    thirdary_find_idx = secondary_find_idx;
    min_n_time_inteval = 0.05 * Fs;
    i = 2;
    del_cnt = 0;
    while i <= length(thirdary_find_idx) - del_cnt
        if thirdary_find_idx(i) - thirdary_find_idx(i - 1) < min_n_time_inteval
            if y5(thirdary_find_idx(i - 1)) < y5(thirdary_find_idx(i))
                thirdary_find_idx(i - 1) = thirdary_find_idx(i);
            end
            thirdary_find_idx(i:end-1) = thirdary_find_idx(i+1:end);
            del_cnt = del_cnt + 1;
        else
            i = i + 1;
        end
    end
    thirdary_find_idx = thirdary_find_idx(1:end-del_cnt);

    find_idx = thirdary_find_idx;

    subplot(6, 1, 6);
    hold on
    plot((find_idx-1)/Fs, y5(find_idx), 'ro');
    subplot(6, 1, 1);
    hold on
    plot((find_idx-1)/Fs, zeros([length(find_idx), 1]), 'yo');

    clear y5 dy5 primary_find_val primary_sort_res primary_find_idx secondary_find_idx;
    waitbar(1, h_wait_bar);
    close(h_wait_bar);
    disp('    OK.');
    disp('Spliting music finished!');
    disp('Begin to find basic frequency...');
    disp('    Preparing...');
    h_wait_bar = waitbar(0, 'Preparing for finding...');

    amp_tolerant_rate_of_base = 0.1;

    base_freqs = [];
    base_freq_idxs = [];
    Xs = cell([0 0]);
    T1s = [];

    disp('    OK.');
    disp('    Finding...');
    waitbar(0, h_wait_bar, 'Finding basic frequencies...');

    % Find basic freqency in each piece of music

    for i = 2 : 1 : length(find_idx)

        this_b = find_idx(i - 1);
        this_e = find_idx(i);
        this_x = x(this_b : this_e);
        this_repeat = 10;
        for j = 1 : 1 : this_repeat
            this_x = [this_x; this_x];
        end
        this_repeat = 2^this_repeat;
        this_X = abs(fft(this_x));
        T1 = (this_e - this_b + 1) * this_repeat / Fs;

        dc_comp = this_X(1);  % Exclude DC component
        this_X = this_X(2:end);
        [max_val, max_idx] = max(this_X);
        amp_level = max_val / 3;
        over_level = (this_X > amp_level);
        [~, first_idx] = max(over_level);

        if first_idx == max_idx
            base_freq_idx = max_idx;
        else

            candidate_idx = 0;
            candidate_times = 0;
            candidate_times_ret = 0;

            while first_idx < max_idx

                % disp("* " + first_idx/T1);

                tmp_times = max_idx / first_idx;

                % disp(tmp_times);

                tmp_ret = abs(tmp_times - round(tmp_times));
                if tmp_times < 20 && tmp_ret < 0.1
                    if (tmp_times < candidate_times && candidate_idx ~= 0)
                        break;
                    end
                    if (candidate_idx == 0 || tmp_ret < candidate_times_ret)
                        should_be_candidate = true;
                        %{
                        if tmp_times ~= 1
                            time_of_this_over_times = 0;
                            time_of_max_over_times = 0;
                            is_times = @(p, q) abs((p/q) - round(p/q)) < 0.1;
                            for k = 1 : 1 : 15 % amp_tolerant_rate_of_base
                                time_of_this = k * first_idx;
                                tolerant_idxs = round(first_idx * amp_tolerant_rate_of_base);
                                if is_times(time_of_this, max_idx)
                                    if max(this_X(time_of_this-tolerant_idxs : time_of_this+tolerant_idxs)) > amp_level
                                        time_of_max_over_times = time_of_max_over_times + 1;
                                    end
                                else
                                    if max(this_X(time_of_this-tolerant_idxs : time_of_this+tolerant_idxs)) > amp_level
                                        time_of_this_over_times = time_of_this_over_times + 1;
                                    end
                                end
                            end

                            if time_of_max_over_times >= round(time_of_this_over_times*time_of_this_over_times*0.5-time_of_this_over_times*0.5+3)-0.05;
                                hould_be_candidate = false;
                            else 
                            end
                        end
                        %}
                        if should_be_candidate == true
                            candidate_idx = first_idx;
                            candidate_times = round(tmp_times);
                            candidate_times_ret = tmp_ret;
                        end
                    end
                end
                [val, tmp_first_idx] = max(over_level(first_idx + 1 : end));
                first_idx = tmp_first_idx + first_idx;
            end

            if candidate_idx >= max_idx || candidate_times == 1 || candidate_idx == 0
                base_freq_idx = max_idx;
            else
                base_freq_idx = candidate_idx;
            end
        end

        % disp("    Origin: " + (i-1) + " ~ " + i + ": " + (base_freq_idx / T1));

        base_freqs = [base_freqs; base_freq_idx / T1];
        base_freq_idxs = [base_freq_idxs; base_freq_idx];
        Xs = [Xs; this_X];
        T1s = [T1s; T1];

        % sound(this_x(1:min(Fs, end)), Fs);

        %{
        figure(2);
        this_X = [dc_comp; this_X];
        plot([0:length(this_X)-1] * (1/T1), this_X);
        disp((i - 1) + " ~ " + i + ": ");
        pause
        %}
        
        waitbar(i / length(find_idx), h_wait_bar);
    end

    clear this_b this_e this_x this_X this_repeat;
    clear over_level candidate_idx candidate_times candidate_times_ret;
    waitbar(1, h_wait_bar);
    disp('    OK.');
    disp('    Checking legitimacy of frequencies found...');
    waitbar(0, h_wait_bar, 'Checking legitimacy...');

    min_freq = 110;
    max_freq = 1500;
    freq_too_low = base_freqs < min_freq;
    freq_too_high = base_freqs > max_freq;
    legal_freq = ~(freq_too_low | freq_too_high);
    if sum(freq_too_low | freq_too_high) ~= 0
        disp('    Warning: A basic frequency is not in the list and will be discarded!');
    end
    base_freqs = base_freqs(legal_freq);
    base_freq_idxs = base_freq_idxs(legal_freq);
    Xs = Xs(legal_freq);
    T1s = T1s(legal_freq);
    std_freqs = generate_std_freqs(min_freq, max_freq);
    modified_base_freqs = nearest_search(std_freqs, base_freqs);

    clear freq_too_low freq_too_high legal_greq;
    waitbar(1, h_wait_bar);
    disp('    OK.');
    disp('Finding basic frequency finished!');
    disp('Begin to get components...');
    disp('    Preparing...');
    waitbar(0, h_wait_bar, 'Preparing for getting components...');

    % Sort by freqs

    [modified_base_freqs, sort_freq_idx] = sort(modified_base_freqs);
    base_freqs = base_freqs(sort_freq_idx);
    base_freq_idxs = base_freq_idxs(sort_freq_idx);
    Xs = Xs(sort_freq_idx);
    T1s = T1s(sort_freq_idx);

    % Get parameters

    component_record = cell(length(std_freqs), 2); % Column 1: freq; column 2: components
    component_record(:, 1) = num2cell(std_freqs);
    component_record_itr = 1;

    is_float_equal = @(f, g) abs(f - g) / g < 1e-5;

    clear sort_freq_idx;
    disp('    OK.');
    disp('    Getting...');
    waitbar(0, h_wait_bar, 'Getting components...');

    for i = 1 : 1 : length(modified_base_freqs)
        max_times = floor(length(Xs{i}) / 2 / base_freq_idxs(i));
        k = [1 : 1 : max_times]';
        mid_freqs = base_freq_idxs(i) * k;
        tolerant_idxs = round(base_freq_idxs(i) * amp_tolerant_rate_of_base);
        left_freqs = mid_freqs - tolerant_idxs;
        right_freqs = mid_freqs + tolerant_idxs;

        component_res = zeros([max_times, 1]);
        for j = 1 : 1 : max_times
            component_res(j) = max(Xs{i}(left_freqs(j):right_freqs(j)));
        end
        component_res  = component_res / component_res(1);

        while is_float_equal(modified_base_freqs(i), component_record{component_record_itr, 1}) == false
            component_record_itr = component_record_itr + 1;
            if component_record_itr > length(std_freqs)
                error('    Error: unknown error!');
            end
        end

        tmp_org = component_record{component_record_itr, 2};
        % disp('=============');
        % disp(tmp_org);
        if size(tmp_org, 2) == 0
            component_record{component_record_itr, 2} = component_res;
        else
            if size(tmp_org, 1) < length(component_res)
                tmp_org = [tmp_org; zeros([ length(component_res) - size(tmp_org, 1), size(tmp_org, 2)])];
            elseif size(tmp_org, 1) > length(component_res)
                component_res = [component_res; zeros([size(tmp_org, 1) - length(component_res), 1])];
            end
            component_record{component_record_itr, 2} = [tmp_org, component_res];
        end
        % disp('-----');
        % disp(component_record{component_record_itr, 2});
        waitbar(i / length(modified_base_freqs), h_wait_bar);
    end

    clear Xs;
    waitbar(1, h_wait_bar);
    disp('    OK.');
    disp('    Cleaning...');
    waitbar(0, h_wait_bar, 'Cleaning...');

    legal_component = logical(zeros([length(std_freqs), 1]));
    for i = 1 : 1 : length(std_freqs)
        if size(component_record{i, 2}, 2) ~= 0
            legal_component(i) = true;
        end
        waitbar(i / length(std_freqs), h_wait_bar);
    end
    component_record = component_record(legal_component, :);

    %{
    for i = 1 : 1 : 11
        figure(i + 2);
        hold on
        tmp = component_record{i,2};
        for j = 1 : 1 : size(tmp, 2)
            plot(component_record{i,2}(:, j));
        end
        title(string(component_record{i,1}) + " Hz");
    end
    %}

    clear legal_component;
    waitbar(1, h_wait_bar);
    disp('    OK.');
    disp('    Merging multidata...');
    waitbar(0, h_wait_bar, 'Merging multidata...');

    base_freq_record = cell2mat(component_record(:, 1));
    component_record = component_record(:, 2);

    for i = 1 : 1 : length(component_record)
        component_record{i} = mean(component_record{i}, 2);
        waitbar(i / length(component_record), h_wait_bar);
    end

    waitbar(1, h_wait_bar);
    waitbar(1, h_wait_bar, 'Finished!');
    disp('    OK.');
    disp('Getting components finished!');
    close(h_wait_bar);

end
