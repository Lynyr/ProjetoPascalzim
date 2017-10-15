Program EQ11N06 ;

uses modulos;
Const
cadast='cadast.dir';
vagastxt='VAGAS.TXT';
Var	cadastros:file of regis;
		registros:regis;
		a:char;
		cargo:string[1];
		dadosvagas:string[31];
		t,b,c,d,e,f,err:integer;
		vetord:vetor;
		vetvagas:array [1..8] of integer;
		nomevagas:array [1..8] of string[20];
		cargos:array [1..6] of integer;
		vagas:Text;
procedure ordena(var vet:vetor; t:integer);	//modulo especifico para utilizar o tipo vetor
var a: integer;
		troca: boolean;
		aux:cc;
begin
		repeat
			t:=t-1;
			troca:=true;
			for a:=1 to t do
				if (vet[a].nom>vet[a+1].nom) then
					begin
						aux:=vet[a];
						vet[a]:=vet[a+1];
						vet[a+1]:=aux;
						troca:=false;
					end;
		until (troca);
end;						
Begin	//Comeco do programa de fato
	assign(vagas,vagastxt);
	reset (vagas);
	repeat		//Obtendo informacoes do arquivo VAGAS.TXT
		t:=t+1;
		readln(vagas,dadosvagas);
		val(copy(dadosvagas,30,2),vetvagas[t],err);	//Vetor vetvagas sera utilizado para separar os classificados nos cargos
		nomevagas[t]:=copy(dadosvagas,2,20);	//Vetor nomevagas sera utilizado para nomear os cursos
	until (eof(vagas));
	t:=0;
	repeat	//Menu inicial
		repeat
			writeln('Deseja mostrar os cadastros por qual ordem?');
			writeln;
			writeln('1 - Candidatos classificados nos cargos em ordem alfabetica');
			writeln('2 - Candidatos em ordem de classificacao por cargo');
			writeln('3 - Todos os candidatos em ordem de classificacao geral');
			writeln;
			write('Opcao escolhida: ');
			read(a);
			writeln;
			writeln;
			val(a,b,err);
		until (err=0);
	until (b>0) and (b<4);	//Validacao
	assign(cadastros,cadast);
	reset(cadastros);
	if (b=1) then	//Cargos em ordem alfabetica
		begin
			repeat
			read(cadastros,registros);
				if (registros.ccl <> 0) then	//Salvando informacoes no vetor que sera organizado
					begin
						t:=t+1;
						vetord[t].p:=registros.num;
						str(registros.car,cargo);					
						vetord[t].nom:=registros.nome;
						insert(cargo,vetord[t].nom,1);	//Colocando o cargo na frente do nome para organizar
					end;					
			until (eof(cadastros));
			ordena(vetord,t);
			e:=1;
			clrscr;
			writeln('CURSO:','   ',e,' ',nomevagas[e]);
			writeln;
			writeln('ORD':3,' ','NUM':4,' ','NOME',' ':33,'NASCIMENTO',' ','CAR':2);
			writeln;
			for c:=1 to t do
				begin
					d:=d+1;
					seek(cadastros,vetord[c].p-1);
					read(cadastros,registros);
					writeln(c:3,' ',registros.num:4,' ',registros.nome:36,' ',copy(registros.data,7,2),'/'
					,copy(registros.data,5,2),'/',copy(registros.data,1,4),' ',registros.car:2);
					if (d=vetvagas[e]) and (e<6) then
						begin
							d:=0;	e:=e+1;
							readln;	clrscr;
							writeln('CURSO:','   ',e,' ',nomevagas[e]);
							writeln;
							writeln('ORD':3,' ','NUM':4,' ','NOME',' ':33,'NASCIMENTO',' ','CAR':2);
							writeln;
						end;
				end;
		end
	else if (b=2) then	//Ordem de classificacao por Cargo
		begin
			repeat
			read(cadastros,registros);
				if (registros.num <> 0) then	//Salvando informacoes no vetor que sera organizado
					begin
						t:=t+1;
						vetord[t].p:=registros.num;
						str(registros.car,cargo);
						str(registros.clc:3,vetord[t].nom);	//salvando a classificacao no cargo no vetor
						insert(cargo,vetord[t].nom,1);	//Acrescentando o numero do cargo a frente da classificacao para organizar
						cargos[registros.car]:=cargos[registros.car]+1;	//Salvando em um vetor o total de concorrentes para determinado cargo			
					end;					
			until (eof(cadastros));
			ordena(vetord,t);
			e:=1;
			b:=1;
			clrscr;
			writeln('CURSO:','   ',e,' ',nomevagas[e]);
			writeln;
			writeln('ORD':3,' ','INSC':4,' ','NOME',' ':33,'N1':3,' ','N2':3,' ','N3':3,' ','N4':3,' ','SOM',' ','NASCIMENTO');
			writeln;
			for c:=1 to t do
				begin
					d:=d+1;
					f:=f+1;
					seek(cadastros,vetord[c].p-1);
					read(cadastros,registros);
					writeln(registros.clc:3,' ',registros.num:4,' ',registros.nome:36,' ',registros.n1:3,' ',registros.n2:3,' ',registros.n3:3,
					' ',registros.n4:3,' ',registros.so:3,' ',copy(registros.data,7,2),'/',copy(registros.data,5,2),'/',copy(registros.data,1,4));
					if (f mod 50=0) then
						begin
							b:=b+1;
							readln;
							clrscr;
							writeln('CURSO:','   ',e,' ',nomevagas[e]);
							writeln;
							writeln('ORD':3,' ','INSC':4,' ','NOME',' ':33,'N1':3,' ','N2':3,' ','N3':3,' ','N4':3,' ','SOM',' ','NASCIMENTO');
							writeln;
						end;
					if (d=cargos[e]) and (e<6) then
						begin
							d:=0;	e:=e+1; f:=0; b:=b+1;
							readln;	clrscr;
							writeln('CURSO:','   ',e,' ',nomevagas[e]);
							writeln;
							writeln('ORD':3,' ','INSC':4,' ','NOME',' ':33,'N1':3,' ','N2':3,' ','N3':3,' ','N4':3,' ','SOM',' ','NASCIMENTO');
							writeln;
						end;
				end;
		end
	else if (b=3) then	//Todos os candidatos por classificacao geral
		begin
			repeat
				read(cadastros,registros);
					if (registros.num <> 0) then	//Salvando informacoes no vetor que sera organizado
						begin
							t:=t+1;
							vetord[t].p:=registros.num;
							str(registros.clg:3,vetord[t].nom);	//Salvando a classificacao geral no vetor para organizar
						end;
			until (eof(cadastros));
			ordena(vetord,t);
			e:=1;
			clrscr;
			writeln('RELACAO ORDEM DE CLASSIFICACAO GERAL');
			writeln('ORD':3,' ','INSC':4,' ','NOME',' ':33,'N1':3,' ','N2':3,' ','N3':3,' ','N4':3,' ','SOM',' ','NASCIMENTO');
			writeln;
			for c:=1 to t do
				begin
					d:=d+1;
					seek(cadastros,vetord[c].p-1);
					read(cadastros,registros);
					writeln(registros.clg:3,' ',registros.num:4,' ',registros.nome:36,' ',registros.n1:3,' ',registros.n2:3,' ',registros.n3:3,
					' ',registros.n4:3,' ',registros.so:3,' ',copy(registros.data,7,2),'/',copy(registros.data,5,2),'/',copy(registros.data,1,4));
					if(d mod 50 = 0) then
						begin
							e:=e+1;
							readln;	clrscr;
							writeln('RELACAO ORDEM DE CLASSIFICACAO GERAL');
							writeln('ORD':3,' ','INSC':4,' ','NOME',' ':33,'N1':3,' ','N2':3,' ','N3':3,' ','N4':3,' ','SOM',' ','NASCIMENTO');
							writeln;
						end;
				end;
		end;
	readln;  
End.
