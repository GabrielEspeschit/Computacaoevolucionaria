function f = mimetismo(X,varargin)
% Calcula função de mimetismo entre lagarto e folhagem de fundo.
% X é uma matriz binária [N x 24], onde cada uma das N linhas
% representa um vetor RGB com cada componente codificada em 8 bits

%% Prepara saída:
N = size(X,1);
f = zeros(N,1);

%% Carregar imagens do problema (minigecko,background). 
% O ambiente onde a populaçao vive pode ser alterado eventualmente.
if nargin>3
    if varargin{2}==0
        load images.mat;
        nb = 1;
        background = backgrounds(1,nb).img;
        bkav = backgrounds(1,nb).bkav;
        save mimetismo_info background bkav minigecko nb;
        ec=0;
    else
        load mimetismo_info.mat;
        kk=nb;
        if varargin{3}<1
            troca = (rand()<=varargin{3});
        else
            troca = ~rem(varargin{2}-1,varargin{3});
        end
        if troca && varargin{2}>1
            load images.mat;
            while kk==nb
                nb = ceil(size(backgrounds,2)*rand());
            end
            background = backgrounds(1,nb).img;
            bkav = backgrounds(1,nb).bkav;
            save mimetismo_info background bkav minigecko nb;
            ec=1;
        else
            ec=0;
        end
    end
else
    load images.mat;
    nb=1;
    background = backgrounds(1,nb).img;
    bkav = backgrounds(1,nb).bkav;
    ec=0;
end

if nargin==5
    xmax=varargin{4};
elseif nargin >1
    xmax=max(1,varargin{2});
else
    xmax=1;
end

%% Posição da tela do lagarto (minigecko) na imagem de fundo (background)
pl = [round(size(background,2)/2 - 1.5*size(minigecko,2)), ...
    round(size(background,2)/2 - 1.5*size(minigecko,2)), ...
    round(size(background,2)/2 + 0.5*size(minigecko,2)), ...
    round(size(background,2)/2 + 0.5*size(minigecko,2))];
pc = repmat([round(size(background,1)/2 - 2*size(minigecko,1)),...
    round(size(background,1)/2 + 0.5*size(minigecko,1))],1,2);


for n=1:N
    %% Preparar o valor das componentes de cor
    x(1,1) = max(1,min(254,bin2dec(strrep(int2str(X(n,1:8)),' ',''))));
    x(1,2) = max(1,min(254,bin2dec(strrep(int2str(X(n,9:16)),' ',''))));
    x(1,3) = max(1,min(254,bin2dec(strrep(int2str(X(n,17:24)),' ',''))));

    %% Calcular função de desempenho
    f(n,1) = sum(sum(abs(x-bkav)));
end


%% Mostrar figura com desempenho médio da população (caso necessário)
if nargin>1
    if varargin{1}==1
        x = zeros(1,3);
        for i=1:4
            % Calcular cor de alguns indivíduos selecionados para exibição
            x(1,1) = max(1,min(254,bin2dec(strrep(int2str(X(round((i-1)*0.25*N)+1,1:8)),' ',''))));
            x(1,2) = max(1,min(254,bin2dec(strrep(int2str(X(round((i-1)*0.25*N)+1,9:16)),' ',''))));
            x(1,3) = max(1,min(254,bin2dec(strrep(int2str(X(round((i-1)*0.25*N)+1,17:24)),' ',''))));
            
            %  Separar área de interesse do plano de fundo:
            bk = background(pl(i):pl(i)+size(minigecko,1)-1,pc(i):pc(i)+size(minigecko,2)-1,:);
            for k=1:3
                g = bk(:,:,k);
                h = minigecko(:,:,k);
                g(find(h==192)) = x(k);
                bk(:,:,k) = g;
            end
            background(pl(i):pl(i)+size(minigecko,1)-1,pc(i):pc(i)+size(minigecko,2)-1,:) = bk;
        end
        
        if nargin>2
            h1=figure(1); 
            imshow(background);
            set(h1,'position',[5   300   650   600])
            title('Amostra de indivíduos da população')
            h2=figure(2);
            hold on;
            a = plot(varargin{2},min(f),'go');
            set(a,'markersize',8,'markerfacecolor','g');
            a = plot(varargin{2},mean(f),'bo');
            set(a,'markersize',8,'markerfacecolor','b');
            %plot(varargin{2},max(f),'r.');
            legend('Melhor','Médio');%,'Pior');
            if(ec), plot([varargin{2} varargin{2}],[0 350],'k-'); end
            title(sprintf('Contraste da população na geração %d',varargin{2}));
            if varargin{2}>0
                figure(h2),set(gca,'XLim',[0 xmax]);
            end
            set(h2,'position',[660   480   600   420])
            
            h3 = figure(3);
            for i=1:N
                x(i,1) = max(1,min(254,bin2dec(strrep(int2str(X(i,1:8)),' ',''))));
                x(i,2) = max(1,min(254,bin2dec(strrep(int2str(X(i,9:16)),' ',''))));
                x(i,3) = max(1,min(254,bin2dec(strrep(int2str(X(i,17:24)),' ',''))));
            end
            
            subplot(311), axis([0 xmax -25 280]); hold on;
            plot(repmat(varargin{2},1,N),x(:,1),'r.'); a=plot(varargin{2},mean(x(:,1)),'ko');
            set(a,'markersize',8,'markerfacecolor','k');
            ylabel('Vermelho')
            title(sprintf('Intensidade média de cores na geração %d',varargin{2}));
            subplot(312), axis([0 xmax -25 280]); hold on;
            plot(repmat(varargin{2},1,N),x(:,2),'g.'); a=plot(varargin{2},mean(x(:,2)),'ko');
            set(a,'markersize',8,'markerfacecolor','k');
            ylabel('Verde')
            subplot(313), axis([0 xmax -25 280]); hold on;
            plot(repmat(varargin{2},1,N),x(:,3),'b.'); a=plot(varargin{2},mean(x(:,3)),'ko');
            set(a,'markersize',8,'markerfacecolor','k');
            ylabel('Azul')
            xlabel('Geração')
            set(h3,'position',[660   20   600   420])
        else
            h1=figure(1); 
            imshow(background);
            set(h1,'position',[5   300   650   600])
        end
        drawnow;
    end
end