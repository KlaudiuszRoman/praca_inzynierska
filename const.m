function[output] = const()
    if probability(80) %stała jest liczbą całkowitą
        number = randi([-9 9],1);
        while number == 0
            number = randi([-9 9],1); %%STAŁA NIE 0
        end
        if number < 0
            output = strcat('(',num2str(number),')');  %%WYPROWADZENIE ujemnej
        else
            output = num2str(number); %%WYPROWADZENIE dodatniej
        end
    else % stała ułamkiem
        counter = randi([-9 9],1);
        while counter == 0
            counter = randi([-9 9],1); %licznik nie może być 0
        end
        
        denominator = randi([-9 9],1);
        while (denominator == 0 | denominator == counter)
            denominator = randi([-9 9],1); %mianownik nie może być 0 bądź licznikiem
        end
        
        nwd = gcd(counter,denominator); %szukanie największego wspólnego dzielnika
        %skracanie ułamka
        if ~(nwd == 1)
            counter = counter/nwd;
            denominator = denominator/nwd;
        end
        
        %normalizacja wyjścia (minus zawsze przy liczniku)
        if (counter < 0 & denominator < 0)
            counter = counter * -1;
            denominator = denominator * -1;
            output = strcat(num2str(counter),'/',num2str(denominator)); %%WYPROWADZENIE
        else if (counter > 0 & denominator > 0)
                output = strcat(num2str(counter),'/',num2str(denominator)); %%WYPROWADZENIE
            else if (counter > 0 & denominator < 0)
                    counter = counter * -1;
                    denominator = denominator * -1;
                    output = strcat('(',num2str(counter),'/',num2str(denominator),')'); %%WYPROWADZENIE
                else 
                    output = strcat('(',num2str(counter),'/',num2str(denominator),')'); %%WYPROWADZENIE
                end
            end
        end
    end
end