% Script que hace todo de una

% Especifico directorio donde estan los datos
directorio = input('Directorio: ','s');
directorio = horzcat(directorio , '/');

% Eligo un canal de un puerto en especifico
puerto = input('Puerto a levantar: ','s');
canal = input('Canal de INTAN a filtrar (X-0XX):  ');
puerto_canal = [puerto '-0' num2str(canal,'%.2d')];

% Cargamos cantidad de trials y tiempo que dura cada uno
ntrials = input('Numero de trials: ');
tiempo_file = input('Tiempo entre estimulos (en s): ');

% Definimos un umbral para threshold cutting (en uV)
thr = input('Threshold para el threshold cutting (en uV):  ');

% Genero songs.mat a partir de las canciones
estimulos = carga_songs(directorio);

% Leer info INTAN
read_Intan_RHD2000_file(horzcat(directorio, 'info.rhd'));
clear notes spike_triggers supply_voltage_channels aux_input_channels 

% Levanto el canal de interes
raw = read_INTAN_channel(directorio, puerto_canal, amplifier_channels);

% Define el filtro
filt_spikes = designfilt('highpassiir','DesignMethod','butter','FilterOrder',...
    4,'HalfPowerFrequency',500,'SampleRate',frequency_parameters.amplifier_sample_rate);

% Aplica filtro
raw_filtered = filtfilt(filt_spikes, raw);
clear puerto canal filt_spikes

% Genero diccionario con nombre de los estimulos y el momento de presentacion
t0s_dictionary = find_t0s(estimulos, ntrials, tiempo_file, board_adc_channels, frequency_parameters, directorio);

% Buscamos spike por threshold cutting
spike_times = find_spike_times(raw_filtered, thr, frequency_parameters);

% Carga datos filtrados y hace un threshold cutting
plot_spikes_shapes(raw_filtered, spike_times, thr, frequency_parameters, directorio)

% Calculo el score para cada estimulo
scores_all = score_calculator(spike_times, t0s_dictionary, estimulos, frequency_parameters);
