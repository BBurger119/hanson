clc;
close all
[xn, fs] = audioread('ziliao.wav');   %读wav文件(知了声)，获得样点值xn和采样频率fs

%计算信号xn的频谱
xn_FFT = fft(xn);               	%FFT频谱分析
xn_FFT_AMP = abs(xn_FFT);      	%求xn的幅度谱
xn_FFT_AMP_db = 20*log10(xn_FFT_AMP/max(xn_FFT_AMP));   %用对数表示

%画xn时域波形
figure
n = 1:length(xn);   		%生成样点横坐标向量
plot(n,xn);             	%以n为横坐标，画xn
axis([1  length(xn) -1 1])  	%设定坐标轴显示范围
xlabel('样点');            	%设定x坐标标记
ylabel('幅度');            	%设定y坐标标记
title('知了声时域波形');   	%设定标题

%画xn的幅度谱(对数形式)
figure
faxis = (0:length(xn)-1)*fs/length(xn);	 	%生成横坐标(频率轴)刻度，FFT的频率范围[0 fs]
plot(faxis,xn_FFT_AMP_db);   			%以faxis为横轴画xn频谱图
axis([0  fs/2 -100 0])     %设定显示范围，由于FFT频谱具有对称性，因此只显示前半部分
xlabel('频率(Hz)');
ylabel('幅度(dB)');
title('知了声幅度谱');

% 设计低通滤波器
Fp = 2000;          	%通带截止频率(Hz) 
Fs = 2500;          	%阻带截止频率(Hz)
Ap = 0.1;            	%通带衰减(dB)
As = 50;             	%阻带衰减(dB)
wp=2*Fp/fs;      	%归一化通带截止频率
ws=2*Fs/fs;       	%归一化阻带截止频率
[N,Wp]=ellipord(wp,ws,Ap,As);   			%确定带通滤波器的阶数和边缘频率
[b,a]=ellip(N,Ap,As,Wp);             	%确定滤波器系数
[h,w]=freqz(b,a);                      %求数字带通滤波器的频率响应
%以下为绘图命令，绘制带通滤波器的幅频响应
figure;
plot(w*fs/(2*pi),20*log10(abs(h)/max(abs(h))));
axis([0,fs/2,-100,0]);
title('数字低通滤波器的幅度响应');
xlabel('频率(Hz)');
ylabel('幅度(dB)');
grid

%利用设计的滤波器对xn进行滤波，得到滤波输出yn
yn = filter(b,a,xn);    					%滤波函数，b和a为滤波器系数，xn是输入信号
audiowrite('acicadaproc.wav', yn, fs, 'BitsPerSample', 8);  %保存滤波后的信号

%画滤波后的信号yn时域波形
figure
n = 1:length(yn);
plot(n,yn);
axis([1  length(yn) -1 1])
xlabel('样点');
ylabel('幅度');
title('低通滤波后知了声时域波形');

%计算滤波后信号yn的频谱
yn_FFT = fft(yn);
yn_FFT_AMP = abs(yn_FFT);
yn_FFT_AMP_db = 20*log10(yn_FFT_AMP/max(yn_FFT_AMP));

figure
faxis = (0:length(yn)-1)*fs/length(yn);
plot(faxis,yn_FFT_AMP_db);
axis([0  fs/2 -100 0])
xlabel('频率(Hz)');
ylabel('幅度(dB)');
title('滤波后知了声幅度谱');
