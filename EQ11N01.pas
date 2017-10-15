Program EQ11N01 ;

uses modulos;
const
path = 'cadast.txt';

var	cadast:Text;
		t,c,d,m,a,e,n,y:integer;
		vdat,vcpf:boolean;
		nome:string[36];
		data:string[8];
		dd,mm,aaaa,num:string[4];
		cargo:string[1];
		cpf:string[11];
		texto,cadastro:string[60];

Begin
	assign(cadast,path);
	append(cadast);
	writeln('Cadastra ate numero da inscricao for negativo');	//condicao para sair do loop
	repeat
		repeat
			begin
				writeln('Numero de inscricao: ');	//cadastra e valida numero de inscricao
				readln(num);
				val(num,n,e);
			end;
		until (e=0) and (n<10000) and (n<>0);	//limita numero de inscricao entre 1 a 9999
		if (n>0) then
		begin
			t:=4-length(num);	//acrescenta '0' caso o número de inscricao tenha menos de 4 caracteres
			for y:=1 to t do
			insert('0',num,1);
			writeln('nome: ');
			readln(nome);
			t:=36-length(nome);	//acrescenta ' ' caso o numero de caracteres seja menor que 36
			for y:=1 to t do
			insert(' ',nome,length(nome)+1);
			repeat
				begin
					writeln('CPF (somente numero): ');
					readln(cpf);
					vcpf:=vercpf(cpf);
				end;
				if (length(cpf)<>11) then	//evita que cpf com menos de 11 caracteres seja aceito
				vcpf:=false;
			until (vcpf);
			repeat
				begin
					writeln('Data de nascimento na ordem dd/mm/aaaa: ');
					readln(d);
					readln(m);
					readln(a);
					vdat:=valdat(d,m,a)
				end
			until (vdat);
			str(d,dd);	//inteiro para string
			if (length(dd)=1) then
				insert('0',dd,1);	//acrescenta '0' caso o dia tenha somente um digito
			str(m,mm);
			if (length(mm)=1) then
				insert('0',mm,1);
			str(a,aaaa);
			insert(aaaa,data,1);
			insert(mm,data,1);
			insert(dd,data,1);
			repeat
				begin
					writeln('Codigo do cargo: ');
					readln(cargo);
					val(cargo,c,e);
				end;
				if (c>6) or (c<1) then	//evita que o codigo do cargo seja maior que 6 e menor que 1
				e:=1;
			until(e=0);
			insert(cargo,cadastro,1);
			insert(data,cadastro,1);
			insert(cpf,cadastro,1);
			insert(nome,cadastro,1);
			insert(num,cadastro,1);
			writeln(cadast,cadastro);
			writeln(' ');
			writeln('-----/-----/-----/-----/-----/-----/-----');	//somente um separador entre um cadastro e outro
			writeln(' ');
			writeln('Proximo cadastro');
			writeln(' ');
		end
	until(n<0);
	close(cadast);
End.
