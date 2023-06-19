% Programmed by   : Huynh Thai Hoang, University of Technology at Ho Chi Minh City. 
% Last updated    : November 25, 2005

clc;%xoa bo man hinh
clear all%xoa bo toan bo du lieu truoc do
rand('state',sum(100*clock));
max_generation=50; %so the he toi da trong qua trinh chay(chay toi toi da 200 the he thi dung lai)
max_stall_generation=25;
epsilon=0.0001; %J chuan(neu the he nao co J<=epsilon tuc la da tim duoc thog so thoa man, GA khong can chay tiep nua)
pop_size=20; % so ca the trong qun the(so cha me)
npar = 4  %co 6 nhiem sac the trong 1 ca the(6 nhiem sac the nay lan luot la Kp1,Ki1, Kd1, Kp2,Ki2,Kd2
range=[-500 -500  -500  -500    ;...
        500 500  500   500 ]; %tam cua cac NST
dec=[1 1 1  1 ];  %vi tri dau cham thap phan
sig=[4 4 4  4 ];  %so chu so co nghia trong moi nhiem sac the

cross_prob = 0.75; %he so lai ghep
mutate_prob = 0.25; %he so dot bien(he so dot bien + he so lai ghep =1)
elitism = 1; %luon giu lai gia tri tot nhat

rho=0.02;  %trong so quyet dinh e1,e2 va u cai nao quan trong voi J hon

par=Init(pop_size,npar,range); %khoi tao 20 ca the cha me dau tien

Terminal=0;        %KHOI DONG
generation = 0;    %CAC GIA TRI
stall_generation=0;%DAU TIEN TRUOC KHI CHAY ga



for pop_index=1:pop_size,                                                       %Khoi tao 
    n1=par(pop_index,1);                                                       %cac the he 
    n2=par(pop_index,2);                                                       %dau tien
    n3=par(pop_index,3);                                                       %(cho chay GA truoc
    n4=par(pop_index,4);    
   
    sim('SCM_PENDULUM_OKE.slx');                                                            %(tuc l cho lai ghep thu truoc khi
    if length(e1)>9500           %lai ghep thiet)
        n1;
        n2;
        n3;
        n4;
             
       
        J=e1'*e1+e2'*e2%rho*(u'*u)
            %J=e4'*e4
            fitness(pop_index)=1/(J+eps);                                       %
    else                                                                        %
            J=10^100;                                                            %
            fitness(pop_index)=1/(J+eps);                                       %
    end                                                                         %
end;                                                                            %
[bestfit,bestchrom]=max(fitness);                                              %

    n1=par(bestchrom,1);                                                       %cac the he 
    n2=par(bestchrom,2);                                                       %dau tien
    n3=par(bestchrom,3);                                                       %(cho chay GA truoc
    n4=par(bestchrom,4);    
   

J0=1/bestfit+0.001;                                  %(do elitism = nen doi hoi phai co 1 cha me tot nhat de so sanh voi cac he he sau, tim toi uu nhat)
%J_min=2000000000000000;
while ~Terminal, %Terminal se bang 1 neu chay du 200 the he hoac trong qua trinh chay co 1 the he con cai c� bestfit thoa man sai so <epsilon
    generation = generation+1;                                                         %truoc moi lan chay cho hien generation tuong ung voi lan chay thu 1,2,3,...(tuong ung generation 1,2,3... hay the he thu 1,2,3... )                                                
    disp(['generation #' num2str(generation) ' of maximum ' num2str(max_generation)]); %
    pop=Encode_Decimal_Unsigned(par,sig,dec);                            %ma hoa thap phan (nhiem sac the cua cac ca the)
    parent=Select_Linear_Ranking(pop,fitness,0.2,elitism,bestchrom);     %sap hang cha me tuyen tinh(cha me tot thi xac suat co con se cao hon, cha me yeu ot thico it con hoac ko co con)
    child=Cross_Twopoint(parent,cross_prob,elitism,bestchrom);           %con cai se duoc sinh ra dua vao lai ghep da diem(trong truong hop nay la hai diem)
    pop=Mutate_Uniform(child,mutate_prob,elitism,bestchrom);             %dot bien theo dang phan bo deu
    par=Decode_Decimal_Unsigned(pop,sig,dec);                            %giai ma ket qua ve lai dang nhiem sac the(la so duong)
    
    for pop_index=1:pop_size,                                           %lan luot test tung ca the trong quan the

    n1=par(pop_index,1);                                                       %cac the he 
    n2=par(pop_index,2);                                                       %dau tien
    n3=par(pop_index,3);                                                       %(cho chay GA truoc
    n4=par(pop_index,4);    
     
                   %
        sim('SCM_PENDULUM_OKE.slx');                                             %tien hanh chay mo phong de kiem tra xem ca the nao toi uu
       % J=(e1'*e1)+(e2'*e2);%+rho*(u'*u); 
       % fitness(pop_index)=1/(J+eps);
       J=e1'*e1+e2'*e2; 
       if ((length(e1)>9500))                                                                          %neu mo phong chay duoc du 10000 mau(100s) thi
        n1
        n2
        n3
        n4
              

      

            J_min=J%+rho*(u'*u);        %tih J dua vao mau thu 8000 den 9500(giay thu 80
            %J=e4'*e4
            fitness(pop_index)=1/(J+eps);                                                             %den giay thu 95)
        else                                                                                %neu mo phong chay chua den duoc giay thu 95 ma da dung
            J=10^100;                                                                        %nghia la gia tri da dao dong dem mat on dinh
            fitness(pop_index)=1/(J+eps);                                                   %tuc Kp1, Ki1, Kd1, Kp2, Ki2, Kd2 ko tot, khog can tinh toan tiep
        end                                                                                 %luc nay cho J la 1 gia tri rat lon(-->bestfit qua nho nen ko duoc chon lam gia tri toi uu)
    end;                                                                                   
    [bestfit(generation),bestchrom]=max(fitness);                             %ca the nao co Kp1, Ki1, Kd1, Kp2, Ki2, Kd2 lam cho J nho nhat, tuc best fit lon nhat 
                                                                              %se duoc chon am ca the toi uu sau khi chay hoan thanh GA, tuc la ca the bestchrom
    
    if generation == max_generation                                  %neu chay du 200 the he rui ma chua co ca the thoa J <=epsilon (o dong thu 10)
        Terminal = 1;                                                %thi cho Terminal=1, stop chuong trinh GA, chon ca the tot nhat trong cac truong hop do lam bestchrom
    elseif generation>1,
        if abs(bestfit(generation)-bestfit(generation-1))<epsilon,
            stall_generation=stall_generation+1;
            if stall_generation == max_stall_generation, Terminal = 1;end   %con trong qua trinh chay ma xuat hien ca the thoa J<=epsilon(dog thu 10) thi cho Terminal =1, dung GA va lay gia tri do lam bestchrom
        else
            stall_generation=0;
        end;
    end;
    
end; %While

plot(1./bestfit)

n1=par(bestchrom,1)    %hien thi
n2=par(bestchrom,2)   %cac nhiem sac the 
n3=par(bestchrom,3)   %Kp1,Ki1, Kd1, Kp2,Ki2,Kd2
n4=par(bestchrom,4)   
J=1/bestfit(end)  %ham tieu chuan tuong ung ca the con tot nhat do
sim('SCM_PENDULUM_OKE.slx');  %tien hanh mo phong lai de kiem tra ca the con tot nhat do cho dap ung he thong nhu the nao


