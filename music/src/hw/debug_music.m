function y = debug_music(f, harm, Fs)
    t = linspace(0, 1 - 1/Fs, Fs)';
    y = zeros(size(t));
    for i = 1 : 1 : length(harm)
        y = y + harm(i) * sin(2 * pi * i * f * t);
    end
end

