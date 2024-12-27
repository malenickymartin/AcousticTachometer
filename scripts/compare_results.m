clc, close all

file_name = "porsche_997_targa4s_open_2007-6";
path_estim = "data/estimations/"+file_name+".mat";
path_annot = "data/annotation/"+file_name+".mat";
path_save = "../report/anotace_vs_odhad/"+file_name+".pdf";

data_estim = load(path_estim);
data_annot = load(path_annot);

fig = figure;
plot(data_estim.t, data_estim.rpms_save, "LineWidth", 4)
hold on
plot(data_annot.frameTimes, data_annot.userInputs, "LineWidth", 4)
plot(t, -(logging(:,7)-1)*500+500, "g", "LineWidth", 4)
grid on
xlim([0, max(max(data_annot.frameTimes), max(data_estim.t))])
xlabel("čas [s]")
ylabel("RPM [ot/min]")
legend("Odhad", "Manuální anotace", "Detekce kolísání")
fontsize(22,"points")
fig.PaperOrientation = "landscape";
fig.Position = [301 71.5000 1.3425e+03 771];
print(path_save,'-dpdf','-bestfit')
