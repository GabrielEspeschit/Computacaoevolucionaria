%% Limpar ambiente Matlab
clear all; close all; clc;

%% Parametros do programa
Npop = 200;         % Tamanho da populacao.
maxgen = 100;       % Numero maximo de geracoes do processo evolutivo.
nbits = 8;          % Numero de bits empregado na representacao do cromossomo
ncr = 3;            % Numero de cromossomos
plotflag = 1;       % Indicador para exibicao da evolucao
pm = 0.01;          % Probabilidade de mutacaoo em um dado locus
of = 'mimetismo';   % funcao de fitness
mort_rand = 0.3;    % probabilidade de morte por causas aleat???rias
mort_pior = 0;      % fracao da populacao que morre por ser menos apta ao ambiente
env_change = 0;    % probabilidade de mudanca ambiental (0 <= env_change <= 1). 
                    % Valores baixos (<0.2) sao mais recomendados
                    % Se o valor de env_change for maior que 1, o ambiente
                    % e trocado deterministicamente a cada env_change geracoes.
rand('twister',1);

%% Gerar popula??????o inicial (aleat???ria)
P = round(rand(Npop,nbits*ncr));        % Gerar popula??????o
f = feval(of,P,plotflag,0,env_change);  % Avaliar indiv???duos
[f,ordem] = sort(f);                    % Ordenar por performance
P = P(ordem,:);                         % Ordenar por performance

%% Ciclo iterativo - gera??????es
for ngen=1:maxgen
    if ngen>25
        mort_pior=0.2;
    end
    % 1) Mortalidade de adultos
    %   a) Morte por causas aleat???rias (p.ex, acidentes, doen???as, etc)
    ac = randperm(Npop);                
    ac = sort(ac(1:ceil((1-mort_rand)*Npop)));
    P = P(ac,:);
    
    %   b) Morte dos menos aptos (preda??????o).
    P = P(1:end-ceil(mort_pior*Npop),:);          
    np = size(P,1);
    
    % 2) Sele??????o para cruzamento e determina??????o de pontos de corte
    Pais = ceil(np*rand(ceil(Npop/2),2));           % Sele??????o de "pais" - aleat???ria
    cuts = 2*ceil((nbits/2-1)*rand(Npop/2,ncr));    % Pontos de corte no DNA, por cromossomo
    
    % 3) Gera??????o dos "filhos" a partir do cruzamento dos "pais"
    Fils = zeros(Npop,nbits*ncr);                       
    for i=1:size(Pais,1)
        for j=1:ncr
            Fils(1+2*(i-1),(j-1)*nbits+1:j*nbits) = [P(Pais(i,1),(j-1)*nbits+1:(j-1)*nbits+cuts(i,j)+1),...
                                                     P(Pais(i,2),(j-1)*nbits+cuts(i,j)+2:j*nbits)];
            Fils(2*i,(j-1)*nbits+1:j*nbits) = [P(Pais(i,2),(j-1)*nbits+1:(j-1)*nbits+cuts(i,j)+1),...
                                               P(Pais(i,1),(j-1)*nbits+cuts(i,j)+2:j*nbits)];
        end
    end
    
    % 4) Ocorr???ncia de eventuais muta??????es;
    M = (rand(size(Fils))<=pm);
    Fils = Fils+M;
    Fils(find(Fils==2))=0;
    
    % 5) Avaliar "filhos" e orden???-los por performance
    f = feval(of,Fils,plotflag,ngen,env_change,maxgen);
    [f,ordem] = sort(f);        % Ordenar por performance
    P = Fils(ordem,:);          % A popula??????o de "pais" ??? substitu???da pelos "filhos"
    
    %if ~mod(ngen,5)
    %    h=figure(1);
    %    saveas(h,sprintf('geckos-g%03d.fig',ngen),'fig');
    %    saveas(h,sprintf('geckos-g%03d.png',ngen),'png');
    %end
end