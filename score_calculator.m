function score_dict = score_calculator(spike_times, t0s_dictionary, estimulos, frequency_parameters);

% Calcula el score para cada estimulo
% El score es la suma total de spikes durante la persentación del estímulo
% menos la señal de ruido

score_dict = struct();

for i = (1:1: length(t0s_dictionary)) % Para cada estimulo
    
    % Guardo el nombre del estimulo
    score_dict(i).name = t0s_dictionary(i).id_estimulo;
    
    % Busco la frecuencia de sampleo de este estimulo
    for j = (1:1: length(estimulos)) % Para cada estimulo
        if score_dict(i).name  == estimulos(j).name
            index_song = j;
        end
    end
    
    % Guardo la frecuencia de sampleo y el largo (en seg) de este estimulo
    song_freq = estimulos(index_song).freq;
    song_len = length(estimulos(index_song).song) / song_freq; % unidades: seg
    
    % Separo los t0s del estimulo
    t0s_aux = t0s_dictionary(i).t0s;
    
    % Seteo contador de spikes en cero
    score_aux = 0;
    noise_aux = 0;
    
    % Sumo los spikes de cada trial
    for k = (1:1:length(t0s_aux)) % Para cada trial
        
        t = t0s_aux(k);
        
        % Sumo spikes que ocurren durante la presentacion del estimulo
        score_aux = score_aux + sum(spike_times > t & ...
            spike_times < t + song_len * frequency_parameters.amplifier_sample_rate);
        
        % Sumo spikes que ocurren despues de la presentacion del estimulo
        noise_aux = noise_aux + sum(spike_times > t + song_len * frequency_parameters.amplifier_sample_rate & ...
            spike_times < t + 2 * song_len * frequency_parameters.amplifier_sample_rate);   
    end
    
    score_dict(i).score = score_aux - noise_aux;
    
end

end

