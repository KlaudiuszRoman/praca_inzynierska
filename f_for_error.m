function [ output ] = f_for_error( x1 , x2 ) % x1, x2 <-string
% output <-string

    %wektor z dostępnymi działaniami do łączenia wywołań funkcji
    %variable(jeśli pierwsze wywołanie nie wygenerowało zmiennej x2, to
    %trzeba funkcji variable użyć jeszcze raz tym razem z x2 jako zmienną
    %główną, a nie pomocniczą)
    dzialania = [ '+','-','*','/' ];
    
    %zmienna wyrażająca to, czy x2 zostało wygenerowane
    czy_jest = false;
    
    %generowanie funkcji: zmienna x1 - zmienna główna, false - nie była
    %jeszcze użyta zmienna główna(bo pierwsze wykonanie funkcji), true - bo
    %jest zmienna pomocnicza, x2 - wprowadzenie zmiennej pomocniczej, 1 -
    %maksymalna ilość wywołań rekurencyjnych
    q = variable( x1 , false , true , x2 , 1 );
    
    %sprawdzenie czy użyta została zmienna pomocnicza(dla zmiennej o
    %długości 1 np. 'x'
    if ( numel(x2) == 1 )
        %przeglądamy wygenerowaną funkcję w poszukiwaniu zmiennej
        %pomocniczej
        for i = 1 : 1 : numel(q)
            if q(i) == x2
                %została użyta zmienna pomocnicza to zmieniamy watrość czy_jest
                czy_jest = true;
            end
        end
    else
        %sprawdzenie czy użyta została zmienna pomocnicza(dla zmiennej o
        %długości 2 np. 'x2'
        if ( numel(x2) == 2 )
            %przeglądamy wygenerowaną funkcję w poszukiwaniu zmiennej
            %pomocniczej
            for i = 1 : 1 : (numel(q)-1)
                if ( q(i) == x2(1) & q(i+1) == x2(2) )
                    %została użyta zmienna pomocnicza to zmieniamy watrość czy_jest
                    czy_jest = true;
                end
            end
        else
            %sprawdzenie czy użyta została zmienna pomocnicza(dla zmiennej o
            %długości 3 np. 'x_2' <-- podkreślenie w latex daje indeks
            %dolny
            if ( numel(x2) == 3 )
                %przeglądamy wygenerowaną funkcję w poszukiwaniu zmiennej
                %pomocniczej
                for i = 1 : 1 : (numel(q)-1)
                    if ( q(i) == x2(1) & q(i+1) == x2(2) & q(i+2) == x2(3) )
                        %została użyta zmienna pomocnicza to zmieniamy watrość czy_jest
                        czy_jest = true;
                    end
                end
            end
        end
    end
    
    %jeśli pierwsze wywołanie funckji variable nie wyprodukowało funkcji
    %dwóch zmiennych, to łączymy tamtą funkcję za pomocą losowego działania
    %z wektora "działania" z kolejną wygenerowaną funkcją(tym razem zmienną główną jest
    %x2, false(bo x2 nie użyte), true - bo można wstawić zmienną x1,
    %podanie zmiennej x1, 0 - nie chcemy już rekurencji wewnątrz funkcji,
    %żeby nie rozrosła się zbytnio
    if ~czy_jest
        q = strcat(q,dzialania(randi([1 4],1)),variable( x2 , false , true , x1 , 0 ));
    end

    %wyprowadzenie funkcji:
    output = q;
end

