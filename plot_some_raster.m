function plot_some_raster(id_estimulos, estimulos, rasters, frequency_parameters, tiempo_file, ntrials, puerto_canal, thr, directorio)
% 
% plot_raster plotea el raster y psth del número de estímulo indicado
%   Detailed explanation goes here

psth_max = ntrials ;

figure()
n = 5 * round(length(id_estimulos)/2);
m = 2;    
j = 0;
k = 0;

for i = id_estimulos
    
    k = k + 1;
    
    if mod(k, 2) == 1
        p = (k - 1)/2 * 10 + 1;
    else
        p = ((k / 2) - 1) * 10 + 2;
    end
    
    % sonido
    j = j + 1;
    h(1) = subplot(n, m , p);
    plot(1000/estimulos(i).freq * (0:1:(length(estimulos(i).song) -1)), estimulos(i).song,'black')
    hold on;
    line([0 tiempo_file*1000],[0 0],'color',[0 0 0]);
    xlim([0 tiempo_file * 1000])
    title(strcat(string(i), " - ",estimulos(i).name), 'Interpreter','None')

    % psth
    j = j + 1;
    h(2) = subplot(n, m, [p + 2, p + 4]);
    histogram(rasters(i).spikes_norm * 1000/frequency_parameters.amplifier_sample_rate , ...
        (1000/frequency_parameters.amplifier_sample_rate) * (-1000:(0.015*frequency_parameters.amplifier_sample_rate):(tiempo_file*frequency_parameters.amplifier_sample_rate)) );
    ylim([0 psth_max]);
    xlim([0 tiempo_file * 1000]);
    

    % raster
    j = j + 1;
    h(j) = subplot(n, m, [p + 6, p + 8]);
    plot((1000/frequency_parameters.amplifier_sample_rate) * rasters(i).spikes_norm, rasters(i).trials_id, '.')  
    xlim([0 tiempo_file * 1000])
    ylim([0 ntrials + 1])
end 

% Linkeo eje x (no se pueden hacer varios links independientes juntos)
linkaxes(h, 'x');

% Titulo general
sgtitle({datestr(now, 'yyyy-mm-dd'); ...
    string(directorio) ; ...
    strcat(string(puerto_canal), "  " , string(thr), "uV", "  ntrials:", string(ntrials), "  t_inter_estimulo:", string(tiempo_file)) }, 'Interpreter','None')

end
