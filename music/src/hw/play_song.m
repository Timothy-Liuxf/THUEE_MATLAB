function play_song(song, tunes, beat_len, base_freq_record, component_record)
Fs = 8000;

res_song = produce_with_record(song, tunes, Fs, beat_len, base_freq_record, component_record);
sound(res_song, Fs);

end

