function sum_total_metabolic_rate = get_sum_total_metabolic_rate(Sx,Sy,k,plotting)
    % for the saddle position defined with an Sx and an Sy, fetch the data
    % outputted by CMC trial and return the total_metabolic_rate
    % throughout the entire simulation
    trial_name = ['Saddle_x_',num2str(Sx),'_y_',num2str(Sy)];
    trial_folder = [pwd,'\Results\', trial_name, '\CMC\'];
    metabolics_reporter = [trial_folder, 'CMC_leg_MetabolicsReporter_probes.sto'];
    metabolics_report = importdata(metabolics_reporter, '\t');

    data = metabolics_report.data;
    textdata = metabolics_report.textdata;
    colheaders = metabolics_report.colheaders;
    
    time = data(:,1);
    total = data(:,2);
    basal = data(:,3);
    biceps_fem_lh = data(:,4);
    biceps_fem_sh = data(:,5);
    glut_max2 = data(:,6);
    vas_int = data(:,7);
    
    if plotting
        figure(k); clf; hold on; box on; grid on;
        set(gcf,'Name',trial_name)
        set(gca,'FontSize',12)
        colororder([0.8 0 0; 0.5 0.5 0.5; 0 0.8 0; 0 0.6 0.6; 0.6 0 0.8; 1 0.5 0]);
        set(groot,'DefaultLineLineWidth', 1.5);
        plot(time, total, 'DisplayName', 'Total Metabolics')
        plot(time, basal, 'DisplayName', 'Basal Metabolics')
        plot(time, biceps_fem_lh, 'DisplayName', 'Biceps Fem LH')
        plot(time, biceps_fem_sh, 'DisplayName', 'Biceps Fem SH')
        plot(time, glut_max2, 'DisplayName', 'Glut Max2')
        plot(time, vas_int, 'DisplayName', 'Vas Int')
        legend('Location','north','FontSize',10)
        xlabel('Time [s]')
        xticks(0:0.1:1)
        ylabel('Metabolic Energy Expenditure Rate [W]')
        hold off;
    end
    sum_total_metabolic_rate = sum(total);
end

