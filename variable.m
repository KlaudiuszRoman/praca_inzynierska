function [ output ] = variable( main , used_main , is_secondary , secondary , a_rek )
%main - zmienna, ktora musi byc; secondary - dodatkowa zmienna
%is_secondary - czy jest druga zmienna (true/false)
%used_main - czy użyta jest main (true/false) <-ważne dlatego, żeby każde
%wywołanie funkcji variable zawsze zwracało funkcję z przynajmniej raz
%używą zmienną główną

%%
% "wpływ zmiennych" na wynik końcowy funkcji:
%  w * funkcje(pod_funkcje) <dzialania> <rekurencja>
%  w generowane jest tylko dla n = 1,2,3 (funkcje trygonometryczne i logarytm)
%  jeśli n = 3 czyli logarytm naturalny, to nie generujemy zmiennej pod_funkcje
%%
    %dostępne funkcje:
    funkcje = {'sin(','cos(','tan(','cot(','asin(','acos(','atan(','acot('};
    
    %dostępne działania:
    dzialania = [ '+','-','/','*','^'];

    %%poglądowy wygląd funkcji:
    %%funkcja: [współczynnik]fun[co_pod_funkcją:zmienna/rekurencja][potęga]<>[rekurencja]
    %%
    
    w = []; %współczynnik
    f = []; %funkcja
    
    %zmienna określająca czy w tym wywołaniu funkcji będzie rekurencja
    czy_rek = false;
    
    % jeśli można robić rekurencję - zmienna wejściowa a_rek > 0
    if a_rek > 0        
        %to prawdopodobieństwo jej wystąpienia będzie 50%
        czy_rek = probability(50);
    end
    
    %zmniejszamy liczbę a_rek(aby uniknąć przekroczenia liczby zagnieżdżeń
    %podanych przy pierwszym wywołaniu funkcji variable
    a_rek = a_rek - 1;
    
    c_w = probability(50);  %czy wystąpi współczynnik
    
    %%
    %losuje rodzaj funkcji/działania
    n = randi([1 5],1);
    %generowanie współczynnika
    if ( c_w & n < 4 )%czy generujemy?
        if probability(15) % 15% stała i zmienna
            if ( probability(50) & is_secondary )
                %współczynnik to: stała*zmienna_pomocnicza*
                w = strcat(const(),'*',secondary,'*');
            else
                %współczynnik to: stała*zmienna_główna*
                w = strcat(const(),'*',main,'*');
                
                %czy zmienna główna we współczynniku jest pierwszą w
                %funkcji
                if(~used_main)
                    main_in_w = true;
                end
                
                %zaznaczenie, że użyto zmiennej głównej:
                used_main = true;           
            end
        else
            if probability(20) % 85%*20%=17% tylko zmienna
                if ( probability(50) & is_secondary )
                    %współczynnik to: zmienna_pomocnicza*
                    w = strcat(secondary,'*');
                else
                    %współczynnik to: zmienna_główna*
                    w = strcat(main,'*');
                    
                    %czy zmienna główna we współczynniku jest pierwszą w
                    %funkcji
                    if(~used_main)
                        main_in_w = true;
                    end
                
                    %zaznaczenie, że użyto zmiennej głównej:
                    used_main = true;
                end
            else  % 68% <---stała
                %największe prawdopodobieństwo, że współczynnik to stała:
                w = strcat(const(),'*');
            end
        end
    end
    %koniec generowania współczynnika
    
    %%
    if ~(n == 3)
        rek_w_fun = probability(50); %prawdopodobieństwo, że rekurencję zrobimy
        %w funkcji wynosi 50%, inaczej będzie poza funkcją
    
        tmp1 = '1*'; %współczynnik nr1
        if probability(50)
            tmp1 = strcat(const(),'*');
        end
        tmp2 = '1*'; %współczynnik nr2
        if probability(50)
            tmp2 = strcat(const(),'*');
        end

        pod_funkcje = [];

        if ( ~(used_main) & ~(czy_rek) )
            %konieczne użycie main, ponieważ nie zostało użyte i nie będzie
            %zagnieżdżeń
            if probability(40) % 40% prawdopodobieństwa, że pod funkcją będzie:
                % współczynnik*x1
                pod_funkcje = strcat(tmp1,main);
                %zaznaczenie, że użyto zmiennej głównej:
                used_main = true;
            else % 60%
                if ( probability(50) & is_secondary ) % 30% jak jest II zmienna
                    % pod funkcją: współczynnik*x1<działanie+-/>współczynnik*x2
                    pod_funkcje = strcat(tmp1,main,dzialania(randi([1 3],1)),tmp2,secondary);
                    %zaznaczenie, że użyto zmiennej głównej:
                    used_main = true;
                else % 30% jeśli jest II zmienna, jeśli nie ma to 60%
                    % pod funkcją: współczynnik*x1<działanie+->stała
                    pod_funkcje = strcat(tmp1,main,dzialania(randi([1 2],1)),const());
                    %zaznaczenie, że użyto zmiennej głównej:
                    used_main = true;
                end
            end
        else %nie trzeba używać main
            if ( czy_rek & rek_w_fun )%jest rekurencja
                if probability(40) % 40% prawdopodobieństwa, że będzie sama rekurencja
                    %pod funkcją będzie: <rekurencja>
                    pod_funkcje = variable(main , used_main , is_secondary , secondary, a_rek);
                else % 60%
                    if probability(50) % 30%
                        if ( probability(50) & is_secondary ) % 15%
                            %zaznaczenie, że użyto zmiennej głównej:
                            used_main = true;
                            %pod funkcją będzie: współczynnik*x1<działanie+-/>współczynnik*x2<działanie+-><rekurencja>
                            pod_funkcje = strcat(tmp1,main,dzialania(randi([1 3],1)),tmp2,secondary,dzialania(randi([1 2],1)),variable(main , used_main , is_secondary , secondary, a_rek));
                        else % 15%
                            %pod funkcją będzie: stała<działanie+-><rekurencja>
                            pod_funkcje = strcat(const(),dzialania(randi([1 2],1)),variable(main , used_main , is_secondary , secondary, a_rek));
                        end
                    else% 30%
                        if ( probability(50) & is_secondary ) % 15%
                            %pod funkcją będzie: współczynnik*x2<działanie+-><rekurencja>
                            pod_funkcje = strcat(tmp2,secondary,dzialania(randi([1 2],1)),variable(main , used_main , is_secondary , secondary, a_rek));
                        else % 15%
                            %zaznaczenie, że użyto zmiennej głównej:
                            used_main = true;
                            %pod funkcją będzie: współczynnik*x1<działanie+-><rekurencja>
                            pod_funkcje = strcat(tmp1,main,dzialania(randi([1 2],1)),variable(main , used_main , is_secondary , secondary, a_rek));
                        end
                    end
                end
            else %nie ma rekurencji
                if probability(40) % 40%
                    if ( probability(50) & is_secondary )
                        % 20% prawdopodobieństwa, że pod funkcją będzie:
                        % współczynnik*x2
                        pod_funkcje = strcat(tmp2,secondary);
                    else
                        % 20% prawdopodobieństwa, że pod funkcją będzie:
                        % współczynnik*x1
                        pod_funkcje = strcat(tmp1,main);
                        %zaznaczenie, że użyto zmiennej głównej:
                        used_main = true;
                    end
                else % 60%
                    if probability(50) % 30%
                        if ( probability(50) & is_secondary ) % 15%, że będzie
                            % pod funkcją: współczynnik*x1<działanie+-/>współczynnik*x2
                            pod_funkcje = strcat(tmp1,main,dzialania(randi([1 3],1)),tmp2,secondary);
                            %zaznaczenie, że użyto zmiennej głównej:
                            used_main = true;
                        else % 15%, że będzie
                            % pod funkcją: <stała>
                            pod_funkcje = strcat(const());
                        end
                    else % 30%
                        if ( probability(50) & is_secondary )
                            % 15% że pod funkcją będzie:
                            % współczynnik*x2<działanie+->stała
                            pod_funkcje = strcat(tmp1,secondary,dzialania(randi([1 2],1)),const());
                        else
                            % 15% że pod funkcją będzie:
                            % współczynnik*x1<działanie+->stała
                            pod_funkcje = strcat(tmp1,main,dzialania(randi([1 2],1)),const());
                            %zaznaczenie, że użyto zmiennej głównej:
                            used_main = true;
                        end
                    end  
                end
            end
        end
    end
    %%
    
    switch n
        case 1 %funckja trygonometryczna | sin-1 | cos-2  | tg-3 | ctg -4 |
            
            %wylosowanie funkcji, dołożenie operacji pod funkcję
            f = strcat(w,funkcje{randi([1 4],1)},pod_funkcje,')');

            %potęgowanie funkcji
            if probability(25) 
                f = strcat(f,'^',num2str(randi([2 5],1)));
            end
            %rekurencja i działanie po funkcji
            if ( czy_rek & ~rek_w_fun )
                f = strcat(f,dzialania(randi([1 2],1)),variable(main,used_main,is_secondary,secondary,a_rek));
            end
            %wyprowadzenie
            output = f;
        case 2 %funckja trygonometryczna| asin-5 | acos-6 | atg-7 | actg-8 |
            %wylosowanie funkcji, dołożenie operacji pod funkcję
            f = strcat(w,funkcje{randi([5 8],1)},pod_funkcje,')');
            if probability(25) %potęgowanie funkcji
                f = strcat(f,'^',num2str(randi([2 5],1)));
            end
            if ( czy_rek & ~rek_w_fun )%rekurencja i działanie po funkcji
                f = strcat(f,dzialania(randi([1 2],1)),variable(main , used_main , is_secondary , secondary, a_rek));
            end
            %wyprowadzenie
            output = f;
        case 3 %logarytm
            if ( is_secondary & czy_rek & probability(50) )
                %postać funkcji: (w*log(zmienna_pomocnicza))
                f = strcat(w,'log(', secondary, ')');
            else
                %postać funkcji: (w*log(zmienna_główna))
                f = strcat(w,'log(', main, ')');
                %zaznaczenie, że użyto zmiennej głównej:
                used_main = true;
            end
            if (czy_rek)
                %postać funkcji:
                %(w*log(zmienna_główna/pomocnicza))<działanie+-*/^><rekurencja>
                f = strcat(f,dzialania(randi([1 5],1)),variable(main,used_main,is_secondary,secondary,a_rek));
            end
            %wyprowadzenie
            output = f;
        case 4 %pierwiastek
            %losujemy stopień pierwisatka
            st_pierw = randi([2 5],1);
            
            f = strcat('(',pod_funkcje,')^(1/',num2str(st_pierw),')');

            if ( czy_rek & ~rek_w_fun )%rekurencja i działanie po funkcji
                f = strcat(f,dzialania(randi([1 2],1)),variable(main,used_main,is_secondary,secondary,a_rek));
            end
            %wyprowadzenie
            output = f;
        case 5 %potęga ^
            if ( czy_rek & ~rek_w_fun )%rekurencja i działanie po funkcji
                f = strcat('(',pod_funkcje,')^',variable(main,used_main,is_secondary,secondary,a_rek));
            else
                %losowanie potęgi z przedziału od -5 do 5 z wyłączeniem 1 i 0
                potega = randi([-5 5],1);
                while ( potega == 1 | potega == 0)
                    potega = randi([-5 5],1);
                end
                f = strcat('(',pod_funkcje,')^',num2str(potega));
            end
            %wyprowadzenie
            output = f;
        otherwise % ?    
    end
end

