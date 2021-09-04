function std_freqs = generate_std_freqs(base_freq, max_freq)

std_freqs = [];
freq_itr = base_freq;
ratio = 2^(1/12);
while freq_itr <= max_freq
    std_freqs = [std_freqs; freq_itr];
    freq_itr = freq_itr * ratio;
end

end
