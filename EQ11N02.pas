Program EQ11N02 ;

uses modulos;
const
path='cadast.txt';
path2='cadast.dir';
var	dados:string[60];
		ano:string[4];
		mes:string[2];
		dia:string[2];
		data:string[8];
		nome:string[36];
		cpf:string[11];
		n:string[4];
		car,num,err:integer;
		origem:Text;
		destino:file of regis;
		cadast:regis;
Begin
assign(origem,path);
assign(destino,path2);
reset(origem);
rewrite(destino);
repeat										//repete ate EOF
	readln(origem,dados);
	n:=copy(dados,1,4);			//Separando a string de 60 em strings menores
	nome:=copy(dados,5,36);
	cpf:=copy(dados,41,11);
	dia:=copy(dados,52,2);
	mes:=copy(dados,54,2);
	ano:=copy(dados,56,4);
	insert(dia,data,1);			//invertendo a ordem da data para ano/mes/dia
	insert(mes,data,1);
	insert(ano,data,1);
	val(n,num,err);					//transformando strings para inteiro
	val(dados[60],car,err);
	cadast.num:=num;				//salvando os dados no registro
	cadast.nome:=nome;
	cadast.cpf:=cpf;
	cadast.data:=data;
	cadast.car:=car;
	seek(destino,num-1);		//posicionando e gravando registro, -1 para evitar primeiro registro vazio (cadastro 0001)
	write(destino,cadast);
until(eof(origem));
close(origem);
close(destino);
End.
