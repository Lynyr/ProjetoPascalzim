Program EQ11N04 ;

Uses modulos ;
const prova1='prova1.txt';
			prova2='prova2.txt';
			cadastro='CADAST.dir';
type
		notas=record		//Registro para salvar a posicao e as respostas do arquivo txt das provas
			p,n1,n2,e1,e2,nr1,nr2:integer;
			m1,m2:real;
		end;
		anotas=array [1..2000] of notas;
		
procedure corrige(var gabarito:string[50];var px:Text;var svnotas:anotas;var t:integer);	//Rotina especifica para este programa, corrige as provas.
var	p,n1,n2,nr1,nr2,e1,e2,a,err:integer;
		dados:string[54];
		respostas:string[50];
		ncad:string[4];
begin
		repeat
			t:=t+1;
			n1:=0; n2:=0;	//Resetando as notas para nao serem somadas com a do cadastro anterior
			nr1:=0;	nr2:=0;
			e1:=0;	e2:=0;
			readln(px,dados);
			ncad:=copy(dados,1,4);		//Separando numero do cadastro
			respostas:=copy(dados,5,50);		//Separando as respostas
			val(ncad,p,err);
			for a:=1 to 25 do
				begin
					if (respostas[a]=gabarito[a]) then	//Verificando respostas da prova 1 do dia selecionado
						n1:=n1+1
					else if (respostas[a]=' ') then	//Verificando nao respondidas
						nr1:=nr1+1
					else	//verificando erros
						e1:=e1+1;
				end;					
			for a:=26 to 50 do
				begin
					if (respostas[a]=gabarito[a]) then	//Verificando respostas da prova 2 do dia selecionado
						n2:=n2+1
					else if (respostas[a]=' ') then	//Verificando nao respondidas
						nr2:=nr2+1
					else	//verificando erros
						e2:=e2+1;
				end;
			svnotas[t].p:=p;		//Salvando valores no vetor
			svnotas[t].n1:=n1;	svnotas[t].n2:=n2;
			svnotas[t].e1:=e1;	svnotas[t].e2:=e2;
			svnotas[t].nr1:=nr1;	svnotas[t].nr2:=nr2;
			svnotas[1].m1:=svnotas[1].m1+n1*4;svnotas[1].m2:=svnotas[1].m2+n2*4;	//Acumulando notas para a media
		until (eof(px));
		svnotas[1].m1:=svnotas[1].m1/t;	//Calculando medias das materias
		svnotas[1].m2:=svnotas[1].m2/t;		
	end;
			
var	p1,p2:Text;
		registro:regis;
		cadast:file of regis;
		gabarito:string[50];
		a:char;
		t,b,c,d,err:integer;
		svnotas:anotas;		//Vetor responsavel por sincronizar as notas com a posicao correta em cadast.dir
Begin
assign(cadast,cadastro);
reset(cadast);
repeat	//Menu inicial
	repeat
		clrscr;
		writeln('Qual prova deseja corrigir? ');
		writeln;
		writeln('1) Prova 1 - Portugues e Matematica');
		writeln('2) Prova 2 - Conhecimento Especifico e Informatica');
		writeln;
		write('Opção escolhida: ');
		read(a);
		val(a,b,err);
	until (err=0);	//Validacao
until (b>0) and (b<4);	//Validacao
if (b=1) then	//Corrige prova 1
	begin
		for b:=1 to 10 do
			insert('AAAAA',gabarito,1);	//Criando gabarito
		assign(p1,prova1);
		reset(p1);
		corrige(gabarito,p1,svnotas,t);
		clrscr;
		d:=1;
		writeln('RELATORIO CORRECAO - ORDEM INSCRICAO':50,'PAGINA:':18,d:3);
		writeln;
		writeln('PORTUGUES':53,'     ','MATEMATICA');
		writeln('NUM':4,' ','N O M E',' ':29,' ','CE':2,' ','ER':2,' ','BR':2,' ','NOT':3,'   ','CE':2,' ','ER':2,' ','BR':2,' ','NOT':3);
		writeln;
		for b:=1 to t do
			begin
				c:=c+1;
				seek(cadast,svnotas[b].p-1);
				read(cadast,registro);
				registro.n1:=svnotas[b].n1*4;   //Salvando as notas no registro
				registro.n2:=svnotas[b].n2*4;
				writeln(svnotas[b].p:4,' ',registro.nome:36,' ',svnotas[b].n1:2,' ',svnotas[b].e1:2,' ',svnotas[b].nr1:2,' ',
				registro.n1:3,'   ',svnotas[b].n2:2,' ',svnotas[b].e2:2,' ',svnotas[b].nr2:2,' ',registro.n2:3);
				if (c mod 50=0) then
					begin;
						d:=d+1;
						readln;
						clrscr;
						writeln('RELATORIO CORRECAO - ORDEM INSCRICAO':50,'PAGINA:':18,d:3);
						writeln;
						writeln('PORTUGUES':53,'     ','MATEMATICA');
						writeln('NUM':4,' ','N O M E',' ':29,' ','CE':2,' ','ER':2,' ','BR':2,' ','NOT':3,'   ','CE':2,' ','ER':2,' ','BR':2,' ','NOT':3);
						writeln;
					end;
				seek(cadast,svnotas[b].p-1);
				write(cadast,registro);       //Gravando registro no cadast.dir
			end;
		readln;
		clrscr;
		d:=d+1;
		writeln('RELATORIO CORRECAO - MEDIAS':50,'PAGINA:':18,d:3);
		writeln;
		writeln('PORTUGUES ===     ':49,svnotas[1].m1:3:2);
		writeln('MATEMATICA ===     ':49,svnotas[1].m2:3:2);
		readln;
		close(p1);		
	end
else if (b=2) then	//Corrige prova 2
	begin
		for b:=1 to 10 do
			insert('BBBBB',gabarito,1);	//Criando gabarito
		assign(p2,prova2);
		reset(p2);
		corrige(gabarito,p2,svnotas,t);
		clrscr;
		d:=1;
		writeln('RELATORIO CORRECAO - ORDEM INSCRICAO':50,'PAGINA:':18,d:3);
		writeln;
		writeln('C. ESPECIFICOS':55,'   ','INFORMATICA');
		writeln('NUM':4,' ','N O M E',' ':29,' ','CE':2,' ','ER':2,' ','BR':2,' ','NOT':3,'   ','CE':2,' ','ER':2,' ','BR':2,' ','NOT':3);
		writeln;
		for b:=1 to t do
			begin
				c:=c+1;
				seek(cadast,svnotas[b].p-1);
				read(cadast,registro);
				registro.n3:=svnotas[b].n1*4;   //Salvando as notas no registro
				registro.n4:=svnotas[b].n2*4;
				registro.so:=registro.n1+registro.n2+registro.n3+registro.n4;
				writeln(svnotas[b].p:4,' ',registro.nome:36,' ',svnotas[b].n1:2,' ',svnotas[b].e1:2,' ',svnotas[b].nr1:2,' ',
				registro.n3:3,'   ',svnotas[b].n2:2,' ',svnotas[b].e2:2,' ',svnotas[b].nr2:2,' ',registro.n4:3);
				if (c mod 50=0) then
					begin
						d:=d+1;
						readln;
						clrscr;
						writeln('RELATORIO CORRECAO - ORDEM INSCRICAO':50,'PAGINA:':18,d:3);
						writeln;
						writeln('C. ESPECIFICOS':55,'   ','INFORMATICA');
						writeln('NUM':4,' ','N O M E',' ':29,' ','CE':2,' ','ER':2,' ','BR':2,' ','NOT':3,'   ','CE':2,' ','ER':2,' ','BR':2,' ','NOT':3);
						writeln;
					end;
				seek(cadast,svnotas[b].p-1);
				write(cadast,registro);       //Gravando registro no cadast.dir
			end;
		readln;
		clrscr;
		d:=d+1;
		writeln('RELATORIO CORRECAO - MEDIAS':50,'PAGINA:':18,d:3);
		writeln;
		writeln('CONHECIMENTOS ESPECIFICOS ===     ':49,svnotas[1].m1:3:2);
		writeln('INFORMATICA ===     ':49,svnotas[1].m2:3:2);
		readln;
		close(p2);		
	end;
	close(cadast);  
End.
