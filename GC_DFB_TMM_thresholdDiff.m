% ������������GC_DFB_TMM.m���ƶ������Թ���������

% ���������ο���Toshihiko Makino--Threshold Condition of DFB Semiconductor Lasers by the Local-Normal-Mode Transfer-Matrix Method: Correspondence to the Coupled-Wave Method
% ��ͼȡֵ�ο���Nakano, Luo, Tada--Facet reflection independent, single longitudinal mode oscillation in a GaAlAs/GaAs distributed feedback laser equipped with a gain~coupling mechanism
clear all;

%�ɦ�L=[2 2+0.2i 2+0.4i 2+0.6i 2+0.8i 2+i]���6��[Na Nb]
Na_group = 3.6*ones(1,6); 
Nb_group = [3.3678 3.3678-0.011226i 3.3678-0.022452i 3.3677-0.033678i 3.3675-0.044903i 3.3674-0.056128i];
N_mean_group = 2./(1./real(Na_group)+1./real(Nb_group));

r_group = (Na_group - Nb_group)./(Na_group + Nb_group);
ta_COE_group = 2*Na_group./(Na_group + Nb_group); % t���ð��� �����ص�������ʽ10a����������t_COE��ʾt/�ص������������Ǹ�z���޹صĳ�������Ӱ�������ֵ��λ�ã���Ӱ�췢���׷�ֵ��
tb_COE_group = 2*Nb_group./(Na_group + Nb_group);
r_cleavage1 = (Na_group-1)./(Na_group+1); % �������1 Na=3.6,r_cleavage = 0.565���趨(д��Na,Nb����ʽ��Ϊ����������)

kappaLAM_group = log(Na_group./Nb_group); % �����������ʽ�ȽϾ�ȷ
% �������³��򣬻��ln(Na/Nb)��2r ���Ʋ���ĶԱ�
% kappaLAM1 = 2*r
% kappaLAM2 = log(Na/Nb)
lambda0 = 1.55; % �� 1.55Ϊ���Ĳ���/�����񲨳� ���
LAM_a_group = lambda0./(4*real(Na_group)); LAM_b_group = lambda0./(4*real(Nb_group));
LAM_group = LAM_a_group + LAM_b_group;
m = 30; % ����Ƴ�30�Թ�դ
Lg_group = LAM_group*m;
kappaLg_group = kappaLAM_group*m;

deltaLg_group = (-10:0.1:10)';
gL_scan_group = 0:0.01:1.2; 

% ����
% beta_s = pi/(2*LAM_s) + delta_s + j*(g-��i)
% ���𣨱��ʽ�к�����[��deltaLg���]�����Ե�д��ѭ���
%�ɦ�=2pi*n/lambda-2pi*n/lambda0��æ˱��ʽ
% lambda=(deltaLg/(Lg*2*pi*N_mean) + 1/lambda0).^(-1);
% alpha_i_a = 2*pi*imag(Na)/lambda; 
% alpha_i_b = 2*pi*imag(Nb)/lambda; 
%%
for a=1:1:length(gL_scan_group)
    for b=1:1:length(deltaLg_group)
        for c=1:1:6 % 6���Lgȡֵ
            gL_scan = gL_scan_group(a);
            deltaLg = deltaLg_group(b);
            Lg = Lg_group(c); LAM_a = LAM_a_group(c); LAM_b = LAM_b_group(c);
            r = r_group(c);Na = Na_group(c);Nb = Nb_group(c);N_mean = N_mean_group(c);
            ta_COE = ta_COE_group(c); tb_COE = tb_COE_group(c);
            r_cleavage = r_cleavage1(c);
            
            lambda=(deltaLg/(Lg*2*pi*N_mean) + 1/lambda0).^(-1);
            alpha_i_a = 2*pi*imag(Na)/lambda;
            alpha_i_b = 2*pi*imag(Nb)/lambda;
            beta_a = pi/(2*LAM_a) + deltaLg/Lg + j*(gL_scan/Lg-alpha_i_a);
            beta_b = pi/(2*LAM_b) + deltaLg/Lg + j*(gL_scan/Lg-alpha_i_b);
%         T11 = exp(-j*beta_b*LAM_b)*(exp(-j*beta_a*LAM_a) - r^2*exp(j*beta_a*LAM_a));
%         T12 = r*(exp(-j*beta_a*LAM_a) - exp(j*beta_a*LAM_a));
%         T21 = -r*(exp(-j*beta_a*LAM_a) - exp(j*beta_a*LAM_a));
%         T22 = exp(j*beta_b*LAM_b)*(exp(j*beta_a*LAM_a) - r^2*exp(-j*beta_a*LAM_a));
            T11 = exp(j*(beta_b*LAM_b+beta_a*LAM_a)) - r^2*exp(-1i*(beta_a*LAM_a-beta_b*LAM_b));
            T12 = r*(exp(-j*(beta_b*LAM_b+beta_a*LAM_a))- exp(j*(beta_a*LAM_a-beta_b*LAM_b)));
            T21 = r*(exp(j*(beta_b*LAM_b+beta_a*LAM_a)) - exp(-j*(beta_a*LAM_a-beta_b*LAM_b)));
            T22 = exp(-j*(beta_b*LAM_b+beta_a*LAM_a)) - r^2*exp(j*(beta_a*LAM_a-beta_b*LAM_b));
            T = (1/(ta_COE*tb_COE))*[T11 T12;T21 T22];
            
            % ��������λ������ġ�Ӧ�á���������ȡ���ҽ���������pi/4�����Ǹ���coldren����AR/HR��Ĥ��ͼ�У�����һ�����/8���Ƶ�ͼȡ��ֵ��
            T_left = Tmatrix_interface(0.05);%r_cleavage);
            T_right = Tmatrix_interface(-0.05);%-r_cleavage);
            
            Tg{a,b,c} = T^m;
            TT{a,b,c} = T_left*Tg{a,b,c}*Tmatrix_line((beta_b*LAM_b)/2)*T_right;
            S21(a,b,c) = (TT{a,b,c}(1))^(-1);
        end
    end
end

%% ���λ���(����ÿ��kappaLg(��m)�� ɨ�������S21���)��Ϊ�˹۲�Ѱ�� 
figure(1);
for c=6:1:6
    for a=1:1:length(gL_scan_group)
        plot(deltaLg_group,abs(S21(a,:,c)));
        ylim([0 100]);% ��Ӧ�������������ݣ����������귶Χ100 20 100
        text(-8.5,95,['��L_g=' num2str(kappaLg_group(c)) ' ' 'c=' num2str(c)],'FontSize',12);
        text(-8,90,['��gL_g=' num2str(gL_scan_group(a)) ' ' 'a=' num2str(a)],'FontSize',12);
        pause;
    end
end

%% ����+1/-1��ģ��ֵ�����꣨gL,��L��
% �۲�S21�õ���ֵ����[row col]
row1 = [100 75 53 29 5]; %+1ģ ��ֵ����gL_scan(a)���̲�����+1�ס�
col1 = [68 69 69 70 70]; %+1ģ ʧг��deltaLg(b)
row2 = [89 80 69 62 52]; %-1ģ ��ֵ����gL_scan(a)
col2 = [135 135 136 136 136]; %-1ģ ʧг��deltaLg(b)
plot(deltaLg_group(col1),gL_scan_group(row1),'*b',deltaLg_group(col2),gL_scan_group(row2),'*r');
xlim([-10 10]);ylim([0 1.2]);
xlabel('\delta L_g');
ylabel('gL');
title('+1/-1��ģ��ֵ');

%% ���� +1/-1��ģ��ֵ�����L�Ĺ�ϵ
x=imag(kappaLg_group(1:5));
y=abs(row2-row1)*0.01;%0.01��gL_scanɨ�辫��
plot(x,y);
xlim([0 0.5]);ylim([0 0.6]);
xlabel('��_g_a_i_n L_g');
ylabel('��gL');
title('+1/-1��ģ��ֵ����������Ϧ�_g_a_i_n �Ĺ�ϵ����_i_n_d_e_sx = 2��');


