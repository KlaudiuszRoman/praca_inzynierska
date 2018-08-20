function [ output ] = probability( input )
%jako wejscie liczba 0 - 100 reprezentująca prawdopodobieństwo wystąpienia
%zdarzenia ; wyjście boolean (true - wydarzenie zaszło)

    a = randi([0 100],1); %losuj liczbę 0-100
    if input >= a          %każda liczba mniejsza od input daje prawdę
        output = true;
    else
        output = false ;    %każda większa fałsz
    end
end

