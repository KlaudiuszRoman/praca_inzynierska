%PROGRAM GŁÓWNY

%wektor zawierający możliwe do wygenerowania grupy:
grupy = ['A','B','C','D','E','F','G','H','I','J'];
ile_grup = 1; %określa liczbę grup
ile_calek = 5; %określa liczbę zadań z całek
ile_pblad = 4; %określa liczbę zadań z propagacji błędu
ile_przpb = 1; % określa liczbę zestawów danych dla zadać z propagacji błędu
%każde wykonanie pętli for to generowanie pytań i odpowiedzi do jednej
%grupy; nie generować więcej grup niż ilość zadeklarowanych nazw w wektorze
%grupy
for grupa = 1 : 1 : ile_grup
    
    %src_pyt i src_odp to zmienne zawierające nazwę pliku .tex dla pytań i
    %odpowiedzi do danej grupy
    src_pyt = strcat('wyniki/pytania',grupy(grupa),'.tex') ;     
    src_odp = strcat('wyniki/odpowiedzi',grupy(grupa),'.tex');

    %utworzenie plików .tex poprzez skopiowanie plików-wzorów zawierających
    %początkowe elementy pojawiające się niezależnie od grupy
    copyfile('wzory/wzor_pytania.tex',src_pyt);
    copyfile('wzory/wzor_odpowiedzi.tex',src_odp);
    
    %otwarcie plików do dopisywania
    fpytania = fopen(src_pyt,'a');
    fodpowiedzi = fopen(src_odp,'a');
    
    %wpisanie do plików numeru grupy, elementów odpowiadających
    %za numerowanie i kolejne jego zagnieżdżenia oraz polecenia
    fprintf ( fpytania , '%s\n' , strcat('GRUPA~',grupy(grupa)));
    fprintf ( fpytania , '%s\n' , '\end{center}');
    fprintf ( fpytania , '%s\n' , '\begin{enumerate}' );
    fprintf ( fpytania , '%s\n' , '\item Oblicz analitycznie całkę' );
    fprintf ( fpytania , '%s\n' , '\begin{enumerate}' );
        
    fprintf ( fodpowiedzi , '%s\n' , strcat('GRUPA~',grupy(grupa)));
    fprintf ( fodpowiedzi , '%s\n' , '\end{center}');
    fprintf ( fodpowiedzi , '%s\n' , '\begin{enumerate}' );
    fprintf ( fodpowiedzi , '%s\n' , '\item' );
    fprintf ( fodpowiedzi , '%s\n' , '\begin{enumerate}' );

    x = sym('x');%utworzenie zmiennej symbolicznej x
    %każde kolejne wykonanie pętli for generuje kolejną przykładową
    %całkę do rozwiązania
    for i = 1 : 1 : ile_calek
        %do zmiennej wynik zapisana jest wygenerowana losowo
        %funkcja(funkcja variable generuje ją w postaci string, więc
        %konwertujemy do postaci symbolicznej)
        wynik = sym(variable ( 'x' , false , false , '' , 1 )); 
        %parametry podane: zmienna podstawowa<'x'>, czy użyte było już
        %'x'(ważne jeśli wywołanie jest rekurencyjne)<false>, czy jest
        %druga zmienna np. a <false>, jaka jest druga zmienna(brak)<''>, ile
        %wywołań rekurencyjnych można wykonać<1>
            
        %do zmiennej przykład zapisujemy pochodną wylosowanej funkcji
        przyklad = diff(wynik , x);

        %jako przykład wyprowadzamy wylosowaną funkcję po
        %różniczkowaniu, dzięki temu wiemy, że zadana do rozwiązania
        %całka ma funkcję pierwotną możliwą do wyrażenia w postaci
        %funkcji pierwotnych; wykonana jest konwrsja do latexa
        
        %%%%%%%%%%zamiana log na ln%%%%%%%%
        
        latex_wynik = latex(wynik);
        K = strfind(latex_wynik,'log');
        while(numel(K)>0)
            latex_wynik = [latex_wynik( 1:(K(1)-1) ) 'ln' latex_wynik( (K(1)+3):end )];
            K = strfind(latex_wynik,'log');
        end
        
        latex_przyklad = latex(przyklad);
        K = strfind(latex_przyklad,'log');
        while(numel(K)>0)
            latex_przyklad = [latex_przyklad( 1:(K(1)-1) ) 'ln' latex_przyklad( (K(1)+3):end )];
            K = strfind(latex_przyklad,'log');
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        fprintf ( fodpowiedzi , '%s\n' ,'\item$' ,  latex_wynik , '$' );
        fprintf ( fpytania , '%s\n' ,'\item$\int' ,  latex_przyklad , 'dx$' );
    end
        
    %zakończenie numerowania dla poprzedniego zadania:
    fprintf ( fpytania , '%s\n' , '\end{enumerate}' );
    fprintf ( fodpowiedzi , '%s\n' , '\end{enumerate}' );
        
    %polecenie do kolejnego zadania:
    fprintf ( fpytania , '%s\n' , '\item Oblicz propagację błędu' );
    fprintf ( fodpowiedzi , '%s\n' , '\item ' );
        
    %zamykamy pliki, będziemy je ponownie otwierać w funkcji er_we_wy
    fclose(fpytania);
    fclose(fodpowiedzi);

    %funkcja generująca zadanie 2 z propagacji błędu; przyjmuje kolejno
    %wartości: ile zestawów danych(2), ile funkcji(5), nazwy plików z
    %pytaniami i odpowiedziami
    er_we_wy( ile_przpb , ile_pblad , src_pyt , src_odp );

    %otwarcie plików do dopisywania 
    fpytania = fopen(src_pyt,'a');
    fodpowiedzi = fopen(src_odp,'a');
    
    %zakończenie numerowania
    fprintf ( fpytania , '%s\n' , '\end{enumerate}}' );
    fprintf ( fodpowiedzi , '%s\n' , '\end{enumerate}}' );
    fprintf ( fpytania , '%s\n' , '\end{document}' );
    fprintf ( fodpowiedzi , '%s\n' , '\end{document}' );

    %zamknięcie plików
    fclose(fpytania);
    fclose(fodpowiedzi);
    
    %kompilacja .tex do .pdf
    system(['pdflatex ' src_pyt]);
    system(['pdflatex ' src_odp]);
    
    %przeniesienie wyników do odpowiedniego folderu
    system(['mv ' 'pytania' grupy(grupa) '.pdf ' 'wyniki/']);
    system(['mv ' 'odpowiedzi' grupy(grupa) '.pdf ' 'wyniki/']);
    
    %porządki
    system(['rm ' 'pytania' grupy(grupa) '.log']);
    system(['rm ' 'pytania' grupy(grupa) '.aux']);
    system(['rm ' 'odpowiedzi' grupy(grupa) '.log']);
    system(['rm ' 'odpowiedzi' grupy(grupa) '.aux']);
end
