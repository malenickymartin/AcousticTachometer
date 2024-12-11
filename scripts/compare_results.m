clear, clc, close all

file_name = "skoda_roomster_open_2010-4.mat";
path_estim = "data/estimations/"+file_name;
path_annot = "data/annotation/"+file_name;

data_estim = load(path_estim);
data_annot = load(path_annot);

plot(data_estim.t, data_estim.rpms_save, "LineWidth", 2)
hold on
plot(data_annot.frameTimes, data_annot.userInputs, "LineWidth", 2)
grid on
xlabel("čas [s]")
ylabel("RPM")
legend("Odhad", "Mechanický tachometr")