Program EQ11N05;

uses modulos;
Const
vagastxt='VAGAS.TXT';
cadast='cadast.dir';		
Var	cadastros:file of regis;
		registro:regis;
		class:vetor;
		a,b,c,t,err:integer;
		dadosvagas:string[31];
		dadosreg:string[8];
		vetvagas:array [1..8] of integer;
		cargos:array [1..6] of integer;
		vagas:Text;
procedure ordena(var vet:vetor; t:integer);		//Rotina especifica para este programa, organiza o vetor pela classificacao
var a,b: integer;
		tro:boolean;
		aux:cc;
begin
	b:=1;
	repeat
		t:=t-b;
		tro:=true;
		for a:=1 to t do
			if (vet[a].nom<vet[a+1].nom) then
				begin
					aux:=vet[a];
					vet[a]:=vet[a+1];
					vet[a+1]:=aux;
					tro:=false;
				end					
	until (tro);
end;		
Begin	//Come�o do programa de fato
	assign(vagas,vagastxt);
	reset (vagas);
	repeat		//Obtendo informacoes do arquivo VAGAS.TXT
		t:=t+1;
		readln(vagas,dadosvagas);
		val(copy(dadosvagas,30,2),vetvagas[t],err);	//Vetor vetvagas sera utilizado para decidir se o candidato foi classificado ou nao
	until (eof(vagas));
	assign(cadastros,cadast);
	reset(cadastros);
	t:=0;	//Resetando o valor de t para o proximo repeat
	repeat
	read(cadastros,registro);
	if(registro.num <> 0) then	//Criando vetor que sera organizado
		begin
			t:=t+1;
			class[t].p:=registro.num;
			val(registro.data,b,err);
			str(20000000-b:8,dadosreg);	//Mudando o valor da data para utilizar o mesmo criterio de organizacao
			insert(dadosreg,class[t].nom,1);	str(registro.n1:3,dadosreg);
			insert(dadosreg,class[t].nom,1);	str(registro.n2:3,dadosreg);
			insert(dadosreg,class[t].nom,1);	str(registro.n4:3,dadosreg);
			insert(dadosreg,class[t].nom,1); 	str(registro.n3:3,dadosreg);
			insert(dadosreg,class[t].nom,1);	str(registro.so:3,dadosreg);
			insert(dadosreg,class[t].nom,1);
		end;
	until (eof(cadastros));	
	ordena(class,t);
	//Usado para auxiliar na verificacao
//	writeln('NUM':4,' ','NOME',' ':32,' ','DATA',' ':6,'C',' ','N1':3,' ','N2':3,
//	' ','N3':3,' ','N4':3,' ','SO':3,'  ','CLG','  ','CLC','  ','CCL ');
	for a:=1 to t do	//Lendo e gravando informacoes no arquivo cadast.dir
		begin
			c:=c+1;
			seek(cadastros,class[a].p-1);
			read(cadastros,registro);
			registro.clg:=a;	//Salvando posicao da classificacao geral
			cargos[registro.car]:=cargos[registro.car]+1;
			registro.clc:=cargos[registro.car];	//Salvando posicao da classificacao no cargo
			if (cargos[registro.car]<=vetvagas[registro.car]) then	//Comparando posicao da classificacao com o numero de vagas
				registro.ccl:=registro.car;	//Se candidato foi classificado, salva o cargo de classificacao
			//Verificando se esta tudo certo
//			writeln(registro.num:4,' ',registro.nome:36,' ',registro.data:8,' ',registro.car:2,' ',registro.n1:3,' ',registro.n2:3,' ',
//			registro.n3:3,' ',registro.n4:3,' ',registro.so:3,' ',registro.clg:4,' ',registro.clc:4,' ', registro.ccl:4);
//			if (c mod 50=0) then
//				begin
//					readln;
//					clrscr;
//					writeln('NUM':4,' ','NOME',' ':32,' ','DATA',' ':6,'C',' ','N1':3,' ','N2':3,
//					' ','N3':3,' ','N4':3,' ','SO':3,'  ','CLG','  ','CLC','  ','CCL ');
//				end;
			//
			seek(cadastros,class[a].p-1);
			write(cadastros,registro);
		end;
	readln;
	close(cadastros); 
End.
