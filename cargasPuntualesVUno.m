function cargasPuntualesVUno()

    % Hecho por:
    % David Josu� Marcial Quero 
    % Diego Solis Higuera 
    % Carlos Augusto Pluma Seda 
    
    close all; clc; % Se limpia la ventana de comandos y se cierran cualquier otro figure que se ten�a previamente
    
    [nPuntos, minX, maxX, minY, maxY, radioC, xCargas, yCargas, k, cargasFinales] = variablesIniciales(); % Funci�n que sirve para obtener los valores iniciales seg�n los
    %inputs del usuario.
    
    [campoElectricoX, campoElectricoY, xPuntosMalla,yPuntosMalla] = ...
    puntosCampoElectrico(nPuntos, minX, maxX, minY, maxY); % Funci�n que sirve para crear los puntos que representaran al campo el�ctrico
    
    [campoElectricoX, campoElectricoY, magnitudCampoETotal] = obtenerCampoElectrico...
    (xPuntosMalla, yPuntosMalla, xCargas, yCargas, k, campoElectricoX,campoElectricoY, cargasFinales); % Funci�n que sirve para calcular los valores del campo el�ctrico
    
    graficaCampoElectrico(xPuntosMalla, yPuntosMalla, campoElectricoX,campoElectricoY, magnitudCampoETotal, radioC, xCargas, yCargas, cargasFinales, minX, maxX, minY, maxY); %Funci�n que sirve
    % Para graficar el campo el�ctrico y el dipolo el�ctrico.
end

function [nPuntos, minX, maxX, minY, maxY, radioC, xCargas, yCargas, k, cargasFinales] = variablesIniciales()
    nPuntos = 25; % Puntos para representar el campo el�ctrico
    
    fprintf("Al ser dos cargas puntuales (dipolo el�ctrico), solo es necesario ingresar un numero \n")
    carga = input("Ingrese el valor de las cargas (un numero positivo): ");
    cargasFinales = [carga, -1*carga]; % Son dos cargas de diferente signo
    
    % El usuario ingresar� la posici�n de las dos cargas
    fprintf("Ingrese la posicion de las 2 cargas \n");
    for i = 1:1:2
        fprintf("Ingrese solo el valor de la posici�n de las carga %d en el eje 'X': ", i);
        posicionX(i) = input("");
        fprintf("Ingrese solo el valor de la posici�n de las carga %d en el eje 'Y': ", i);
        posicionY(i) = input("");
    end
    
    % Determinar la distancia m�s grande entre las cargas para establecer los l�mites del campo el�ctrico
    if abs(posicionX(2)-posicionX(1)) > abs(posicionY(2)-posicionY(1))
        rango = abs(posicionX(2)-posicionX(1));
    else
        rango = abs(posicionY(2)-posicionY(1));
    end
    
    radioC = ((rango) / (nPuntos - 1)); % Radio de la carga
    
    maxX = ((posicionX(2) + posicionX(1))/2) + (rango/2) + (radioC * 4);
    minX = ((posicionX(2) + posicionX(1))/2) - (rango/2) - (radioC * 4); % L�mites del campo el�ctrico en X
    maxY = ((posicionY(2) + posicionY(1))/2) + (rango/2) + (radioC * 4);
    minY = ((posicionY(2) + posicionY(1))/2) - (rango/2) - (radioC * 4); % L�mites del campo el�ctrico en Y
        
    xCargas = [posicionX(1), posicionX(2)]; % Valor de las posiciones de las cargas en X
    yCargas = [posicionY(1), posicionY(2)]; % Valor de las posiciones de las cargas en Y
    
    eps = 8.854e-12; % C�lculo del valor de la constante el�ctrica en el vac�o
    k = 1/(4*pi*eps);
end

function [campoElectricoX, campoElectricoY, xPuntosMalla,yPuntosMalla] = ...
    puntosCampoElectrico(nPuntos, minX, maxX, minY, maxY)

    % Definir espacio para guardar campo electrico en los componentes x y y
    campoElectricoX = zeros(nPuntos);
    campoElectricoY = zeros(nPuntos);

    % Creamos vectores para trabajar con el meshgrid
    X = linspace(minX,maxX,nPuntos);
    Y = linspace(minY,maxY,nPuntos);
    
    % Creamos la malla
    [xPuntosMalla,yPuntosMalla] = meshgrid(X,Y);
end

function [campoElectricoX, campoElectricoY, magnitudCampoETotal] = obtenerCampoElectrico...
    (xPuntosMalla, yPuntosMalla, xCargas, yCargas, k, campoElectricoX,...
    campoElectricoY, cargasFinales)

    % Recorrido de las cargas para calcular campo electrico
    for i = 1:1:2
        distanciaX = xPuntosMalla - xCargas(i);
        distanciaY = yPuntosMalla - yCargas(i);
        R = sqrt(distanciaX .^2 + distanciaY .^2); % C�lculo de la distancia
        R3 = R.^3;
        campoElectricoX = campoElectricoX + ((k .* cargasFinales(i) .* distanciaX) ./R3);
        campoElectricoY = campoElectricoY + ((k .* cargasFinales(i) .* distanciaY) ./R3);
    end
    
    magnitudCampoETotal = sqrt(campoElectricoX .^2 + campoElectricoY .^2); % Se calcula la magnitud del campo magn�tico en base al vector.

end

function graficaCampoElectrico(xPuntosMalla, yPuntosMalla, campoElectricoX, campoElectricoY, magnitudCampoETotal, radioC, xCargas, yCargas, cargasFinales, minX, maxX, minY, maxY)

    % Graficacion con quiver
    quiver(xPuntosMalla, yPuntosMalla, campoElectricoX ./ magnitudCampoETotal, campoElectricoY ./ magnitudCampoETotal)
    % Se divide para normalizar el tama�o
    hold on
    contour(xPuntosMalla(1,:), yPuntosMalla(:,1), campoElectricoX ./ magnitudCampoETotal)
    xlim([minX, maxX])
    ylim([minY, maxY])
    xlabel("X[m]");
    ylabel("Y[m]");
    axis square
    % Para pos_ xCargas(1) es el centro de la carga, y para dibujar la carga,
    % queremos la esquina inferior derecha, por eso se le resta radioC
    for i = 1:1:2
        pos_x = xCargas(i) - radioC;
        pos_y = yCargas(i) - radioC;
        % Se multiplica por dos porque queremos el di�metro del c�rculo
        if cargasFinales(i) < 0
            rectangle('Position',[pos_x, pos_y, 2*radioC,  2*radioC],'Curvature',[1, 1],'FaceColor', 'r' ,'EdgeColor',[0 0 1])
            text(xCargas(i), yCargas(i),'-','Color','white','FontSize',25)
        else
            rectangle('Position',[pos_x, pos_y, 2*radioC,  2*radioC],'Curvature',[1, 1],'FaceColor', 'b' ,'EdgeColor',[0 0 1])
            text(xCargas(i), yCargas(i),'+','Color','white','FontSize',25)
        end
    end
end
