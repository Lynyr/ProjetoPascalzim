Program EQ11N03 ;

uses modulos;
const
path='cadast.dir';
var	cadastros:file of regis;
		dados:regis; 
		aux,dados2:cc;
		input,a,t,n,tot,jt,c:integer;
		vetdados2:vetor;		
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
Begin	//comeco do programa de fato
assign(cadastros,path);
reset(cadastros);
t:=1;
	repeat
		writeln('Ordenar por: 1 = nome, 2 = cpf, 3 = data, 4 = sair');
		readln(input);
	until (input>0) and (input<5);
	if (input>0) and(input<4)then
	begin
		if (input=1) then	//ordenar por nome
			repeat                                                                     
				readln(cadastros,dados);
				if (dados.num<>0) then
				begin
					dados2.p:=dados.num;
					dados2.nom:=dados.nome;
					vetdados2[t]:=dados2;
					t:=t+1;
					end;	
			until(eof(cadastros))
		else if(input=2) then	//ordenar por cpf
			repeat
				readln(cadastros,dados);
				if (dados.num<>0) then
				begin
					dados2.p:=dados.num;
					dados2.nom:=dados.cpf;
					vetdados2[t]:=dados2;
					t:=t+1;
				end	
			until(eof(cadastros))
		else if(input=3) then	//ordenar por data de nascimento
			repeat
				readln(cadastros,dados);
				if (dados.num<>0) then
				begin
					dados2.p:=dados.num;
					dados2.nom:=dados.data;
					vetdados2[t]:=dados2;
					t:=t+1;
				end	
			until(eof(cadastros));		
			t:=t-1;	//corrige o valor de t
			ordena(vetdados2,t);
			writeln(' NUM',' NOME',' ':33,'CPF',' ':9,'DATA     ','C ','N1 ','N2 ','N3 ','N4 ','SO ','CG ','CC ','CV ');
			for a:=1 to t do
				begin
					c:=c+1;	//contador para limpar a tela a cada 50 cadastros
					n:=vetdados2[a].p;
					seek(cadastros,n-1);	//-1 para sincronizar com o valor do dir, que começa em 0 (cadastro 0001)
					readln(cadastros,dados);
					writeln(dados.num:4,' ',dados.nome,' ',dados.cpf,' ',dados.data,' ',dados.car,'  ',dados.n1,'  ',dados.n2,'  ',dados.
					n3,'  ',dados.n4,'  ',dados.so,'  ',dados.clg,'  ',dados.clc,'  ',dados.ccl);
					if (c mod 50=0) then	//limpa a tela a cada 50 cadastros depois de apertar alguma tecla
						begin
							readln;
							clrscr;
							writeln(' NUM',' NOME',' ':33,'CPF',' ':9,'DATA     ','C ','N1 ','N2 ','N3 ','N4 ','SO ','CG ','CC ','CV ');
						end;
				end;
			readln;	//evita que o programa feche nos ultimos cadastros
	end			
	else				
close(cadastros);
End.
