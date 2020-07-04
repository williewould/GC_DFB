clear all;

%Na = 3.22; Nb = 2.888839004576706; %�ɦ�L=3.32558+0j���һ����� ����1��
%Na = 3.22; Nb = 2.596922074398683; %�ɦ�L=6.451633+0j���һ����� ����2��
%Na = 3.22; Nb = 2.891556951572583 - 0.031044851809367i;%�ɦ�L=3.225859+0.322079j���һ����� ��������
Na = 3.22; Nb = 3.098876636825481 - 0.310924771189149i;%�ɦ�L=1+3i���һ����ϡ���һ����1989Nakano��

r = (Na-Nb)/(Na+Nb);
ta_COE = 2*Na/(Na+Nb); % t���ð��� �����ص�������ʽ10a����������t_COE��ʾt/�ص������������Ǹ�z���޹صĳ�������Ӱ�������ֵ��λ�ã���Ӱ�췢���׷�ֵ��
tb_COE = 2*Nb/(Na+Nb);
kappaLAM = log(Na/Nb); % �����������ʽ�ȽϾ�ȷ
% �������³��򣬻��ln(Na/Nb)��2r ���Ʋ���ĶԱ�
% kappaLAM1 = 2*r
% kappaLAM2 = log(Na/Nb)
lambda0 = 1.55; % �� 1.55Ϊ���Ĳ���/�����񲨳� ���
LAM_a = lambda0/(4*real(Na)); LAM_b = lambda0/(4*real(Nb));
LAM = LAM_a + LAM_b;
m = 30; % ����Ƴ�30�Թ�դ
Lg = LAM*m;
kappaLg = kappaLAM*m;
deltaLg = (-15:0.05:15)';
gL_scan = 0:0.02:1; 

% beta_s = pi/(2*LAM_s) + delta_s + j*g

for a=1:1:length(gL_scan)
    for b=1:1:length(deltaLg)
        beta_a = pi/(2*LAM_a) + deltaLg(b)/Lg + j*gL_scan(a)/Lg;
        beta_b = pi/(2*LAM_b) + deltaLg(b)/Lg + j*gL_scan(a)/Lg;
%         T11 = exp(-j*beta_b*LAM_b)*(exp(-j*beta_a*LAM_a) - r^2*exp(j*beta_a*LAM_a));
%         T12 = r*(exp(-j*beta_a*LAM_a) - exp(j*beta_a*LAM_a));
%         T21 = -r*(exp(-j*beta_a*LAM_a) - exp(j*beta_a*LAM_a));
%         T22 = exp(j*beta_b*LAM_b)*(exp(j*beta_a*LAM_a) - r^2*exp(-j*beta_a*LAM_a));
        T11 = exp(j*(beta_b*LAM_b+beta_a*LAM_a)) - r^2*exp(-j*(beta_a*LAM_a-beta_b*LAM_b));
        T12 = r*(exp(-j*(beta_b*LAM_b+beta_a*LAM_a) )- exp(j*(beta_a*LAM_a-beta_b*LAM_b)));
        T21 = r*(exp(j*(beta_b*LAM_b+beta_a*LAM_a)) - exp(-j*(beta_a*LAM_a-beta_b*LAM_b)));
        T22 = exp(-j*(beta_b*LAM_b+beta_a*LAM_a)) - r^2*exp(j*(beta_a*LAM_a-beta_b*LAM_b));
        T = (1/(ta_COE*tb_COE))*[T11 T12;T21 T22];
        Tg{a,b} = T^m;
        S21(a,b) = (Tg{a,b}(1))^(-1);
    end
end

%% ���λ���(����ÿ��kappaLg(��m)�� ɨ�������S21���)��Ϊ�˹۲�Ѱ�� 
figure(1);
for a=1:1:length(gL_scan)     
    plot(deltaLg,abs(S21(a,:)));
    ylim([0 100]);% ��Ӧ�������������ݣ����������귶Χ100 20 100
    text(-13.5,95,['��L_g=' num2str(kappaLg)],'FontSize',12);
    text(-13.5,90,['(��g-��_i)L_g=' num2str(gL_scan(a)) ' ' 'a=' num2str(a)],'FontSize',12);
    pause;
end

%% ��������ֵ�����꣨gL,��L��
M = max(abs(S21(42,:))); % 29�ǹ۲�����䣨��Ӧ�������̳�������ĸΪ0�����㣩�Ľ�������ݹ۲���������ֵ��
% �������ӷֱ�29(��)�� 11(��)��[16(0��) 42(1��)]
[row col] = find(abs(S21)==M);
disp(['��L=' num2str(kappaLg) '��DFB����������ֵ�������Ӧ��һ��Ƶ��λ��Ϊ��']);
disp(['(gL,��L)=(' num2str(gL_scan(row)) ',' num2str(deltaLg(col)) ')']);

%% ��һ������ͷ����ף��������߻���һ��
A=abs(S21(27,:));
B=abs(S21(22,:));
C=abs(S21(17,:));
max=max(A);A=A./max;clear max;
max=max(B);B=B./max;clear max;
max=max(C);C=C./max;clear max;
result=zeros(length(B),3);result(:,1)=A;result(:,2)=B;result(:,3)=C;
plot(deltaLg,result);legend('gL','gL-0.1','gL-0.2');
