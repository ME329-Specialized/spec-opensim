function [time, biceps_fem_lh, biceps_fem_sh, glut_max2, vas_int, sum_total_metabolic_rate] = get_sum_total_metabolic_rate(Sx,Sy,k,plotting)
    % for the saddle position defined with an Sx and an Sy, fetch the data
    % outputted by CMC trial and return the total_metabolic_rate
    % throughout the entire simulation
    
    % also returns the raw data for the 4 muscles included in the CMC model
    % as of 2/28/2021
    trial_name = ['Saddle_x_',num2str(Sx),'_y_',num2str(Sy)];
    trial_folder = [pwd,'\Results\', trial_name, '\CMC\'];
    metabolics_reporter = [trial_folder, 'CMC_leg_MetabolicsReporter_probes.sto'];
    metabolics_report = importdata(metabolics_reporter, '\t');

    data = metabolics_report.data;
    textdata = metabolics_report.textdata;
    colheaders = metabolics_report.colheaders;
    
    smooth_method = 'movmean';
    ws = 10; % window size
    time = data(:,1) - 0.06;
    total = smoothdata(data(:,2), smooth_method, ws);
    basal = smoothdata(data(:,3), smooth_method, ws);
    biceps_fem_lh = smoothdata(data(:,4), smooth_method, ws);
    biceps_fem_sh = smoothdata(data(:,5), smooth_method, ws);
    glut_max2 = smoothdata(data(:,6), smooth_method, ws);
    vas_int = smoothdata(data(:,7), smooth_method, ws);
    
    x_offset = -0.126;
    y_offset = 0.84999999999999998;
    fs = 16;
    if plotting
        figure(k); clf; hold on; box on; grid on;
        set(gcf,'Name',trial_name)
        set(gca,'FontSize',fs)
        colororder([0.8 0 0; 0.5 0.5 0.5; 0 0.8 0; 0 0.6 0.6; 0.6 0 0.8; 1 0.5 0]);
        set(groot,'DefaultLineLineWidth', 1.5);
        plot(time, total, 'DisplayName', 'Total Metabolics')
        plot(time, basal, 'DisplayName', 'Basal Metabolics')
        plot(time, biceps_fem_lh, 'DisplayName', 'Biceps Fem LH')
        plot(time, biceps_fem_sh, 'DisplayName', 'Biceps Fem SH')
        plot(time, glut_max2, 'DisplayName', 'Glut Max2')
        plot(time, vas_int, 'DisplayName', 'Vas Int')
        legend('Location','north','FontSize',fs)
        xlabel('Time [s]')
        ylabel('Metabolic Energy Expenditure Rate [W]')
        xticks(0:0.1:1)
        axis([0 0.75 -inf inf])
%         title(['Trial ',num2str(k),' with S_{x,y} = (',num2str(Sx+x_offset),...
%             ',',num2str(Sy+y_offset),') m'])
        hold off;
        
    end
    sum_total_metabolic_rate = mean(total);
end

