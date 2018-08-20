function [ output ] = er_we_wy( ile_prz , ile_zad , src_pyt , src_odp )
    %ile_prz <- ile przypadków
    %ile_zad <- ile zadań
    %src_pyt <- plik z pytaniami
    %src_pyt <- plik z odpowiedziami

    x1p = []; % wartość x1
    x2p = []; % wartość x1

    delta_x1 = []; % błąd x1
    delta_x2 = []; % błąd x2

    dy_dx1 = []; % pochodna po x1
    dy_dx2 = []; % pochodna po x2

    y_dx1 = []; % podstawienie
    y_dx2 = [];

    blad = []; % propagacja błędu

    %otwarcie plików do dopisywania oraz elementy numerowania:
    fpytania = fopen(src_pyt,'a');
    fodpowiedzi = fopen(src_odp,'a');
    fprintf ( fpytania , '%s\n' , '\begin{enumerate}' );
    fprintf ( fodpowiedzi , '%s\n' , '\begin{enumerate}' );
    
    %każde wykonanie pętli for odpowiada za wygenerowanie jednego
    %zadania:
    for j = 1 : 1 : ile_zad
        %utworzenie zmiennych symbolicznych x1 i x2
        x1 = sym('x_1');
        x2 = sym('x_2');
        
        %f_for_error generuje losową funkcję dwóch zmiennych, jako parametr
        %przyjmuje w postaci string obie zmienne
        y = sym(f_for_error('x_1','x_2'));
        
        %zamiana log na ln
        latex_y = latex(y);
        K = strfind(latex_y,'log');
        while(numel(K)>0)
            latex_y = [latex_y( 1:(K(1)-1) ) 'ln' latex_y( (K(1)+3):end )];
            K = strfind(latex_y,'log');
        end
        
        %wyprowadzenie wygenerowanej funkcji do pliku:
        fprintf ( fpytania , '%s\n' , '\item' , '$y=' , latex_y , '$' );
        fprintf ( fodpowiedzi , '%s\n' , '\item' , '$y=' , latex_y , '$' );
        
        %numerowanie:
        fprintf ( fpytania , '%s\n' , '\begin{enumerate}[I.]' );
        fprintf ( fodpowiedzi , '%s\n' , '\begin{enumerate}[I.]' );
        
        %każde wykonanie for to zastaw przykładowych wartości zmiennych
        %oraz ich błędów
        for  i = 1 : 1 : ile_prz
            
            %losujemy wartości zmiennych z przedziału od -5 do 5
            x1p(i) = randi([-5 5],1);
            x2p(i) = randi([-5 5],1);
            
            %losujemy błędy dla zmiennych z przedziału od 0.01 do 0.05
            delta_x1(i) = randi([1 5],1)/100;
            delta_x2(i) = randi([1 5],1)/100;
            
            %różniczkujemy funkcję po x1:
            dy_dx1 = diff (y, x1);
            %oraz po x2:
            dy_dx2 = diff (y, x2);
            
            %zabezpieczenie przed podstawianiem wartości poza dziedziną
            %funkcji
            error = true;
            while(error)%dopóki error prawdziwe
                try 
                    %podstawienie danych do pochodnych cząstkowych
                    y_dx1 = subs( dy_dx1 , {x1,x2} , {x1p(i),x2p(i)} , 2 );
                    y_dx2 = subs( dy_dx2 , {x1,x2} , {x1p(i),x2p(i)} , 2 );
                    
                    %wyliczenie błędu propagacji:
                    blad = abs(y_dx1) * abs(delta_x1(i)) + abs(y_dx2) * abs(delta_x2(i));
                    blad = abs(blad);
                    %obliczenie wyniku funkcji z wygenerowanych danych:
                    wynik = subs( y , {x1,x2} , {x1p(i),x2p(i)} , 2 );
                    
                    %w przypadku zwrócenia wyniku NaN lub Inf
                    if ( isnan(wynik) == 1 | isinf(wynik) == 1 | isnan(y_dx1) | isnan(y_dx2) | isinf(y_dx1) | isinf(y_dx2) )
                        q = 2/0; %trochę brutalne
                    end
                    
                    %jeśli wszystko się wykona:
                    error = false; %wyjście z while
                catch
                    %jeśli nie w dziedzinie to generowanie nowego zestawu
                    %danych:
                    x1p(i) = randi([-5 5],1);
                    x2p(i) = randi([-5 5],1);
                end
            end
            
            %wygenerowany zestaw danych(zmienne, błędy):
            fprintf ( fpytania , '%s%2.0f%s%.3f%s\n' , '\item$x_1=',x1p(i), '\pm' , delta_x1(i),'\\' );
            fprintf ( fodpowiedzi , '%s%2.0f%s%.3f%s\n' , '\item$x_1=',x1p(i), '\pm' , delta_x1(i),'\\' );
           
            fprintf ( fpytania , '%s%2.0f%s%.3f%s\n' , 'x_2=' , x2p(i), '\pm' , delta_x2(i) ,'$' );
            fprintf ( fodpowiedzi , '%s%2.0f%s%.3f%s\n' , 'x_2=' , x2p(i), '\pm' , delta_x2(i) ,'\\' );
            
            %zamiana log na ln
            latex_dy_dx1 = latex(dy_dx1);
            K = strfind(latex_dy_dx1,'log');
            while(numel(K)>0)
                latex_dy_dx1 = [latex_dy_dx1( 1:(K(1)-1) ) 'ln' latex_dy_dx1( (K(1)+3):end )];
                K = strfind(latex_dy_dx1,'log');
            end
            
            latex_dy_dx2 = latex(dy_dx2);
            K = strfind(latex_dy_dx2,'log');
            while(numel(K)>0)
                latex_dy_dx2 = [latex_dy_dx2( 1:(K(1)-1) ) 'ln' latex_dy_dx2( (K(1)+3):end )];
                K = strfind(latex_dy_dx2,'log');
            end
            
            %pochodne cząstkowe:
            fprintf ( fodpowiedzi , '%s\n' , '\frac{\partial f}{\partial x_1}=' , latex_dy_dx1 , '\\' );
            fprintf ( fodpowiedzi , '%s\n' , '\frac{\partial f}{\partial x_2}=' ,latex_dy_dx2 , '\\' );
            %prawo przenoszenia:
            blad_d = double(blad);
            wynik_d = double(wynik);
            fprintf ( fodpowiedzi , '%s%3.10f%s\n' ,'\Delta f(x)=\Big|\frac{\partial f}{\partial x_1}\Big|*\Delta x_1+\Big|\frac{\partial f}{\partial x_2}\Big|*\Delta x_2=',blad_d,'$\\');
            %wynik funkcji +- błąd propagacji
            fprintf ( fodpowiedzi , '%s%3.10f%s%3.10f%s\n' , '$f(x_1,x_2)=',wynik_d,'\pm' , blad_d , '$' );
              
        end
        %numerowanie:
        fprintf ( fpytania , '%s\n' , '\end{enumerate}' );
        fprintf ( fodpowiedzi , '%s\n' , '\end{enumerate}' );
    end
    %numerowanie:
    fprintf ( fpytania , '%s\n' , '\end{enumerate}' );
    fprintf ( fodpowiedzi , '%s\n' , '\end{enumerate}' );
    
    %zamknięcie plików
    fclose(fpytania);
    fclose(fodpowiedzi);
end