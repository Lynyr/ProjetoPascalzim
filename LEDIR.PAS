

program ledir;
uses crt,modulos;
var reg2:regis;
    arq2:file of regis;
    a,b,c,p,e,t,PAG:integer;
PROCEDURE CABECA;{MODULO ESPECIFICO PARA ESTE PROGRAMA}
BEGIN
 CLRSCR ;
 PAG:=PAG+1;
 WRITELN('                         RELATORIO GERAL - ORDEM INSCRICAO             PAGINA:',PAG:3);
 WRITELN;
 write('  ORD  NUM N O M E                              ===C P F=== NASCIMENTO CS  N1');
 WRITELN('  N2  N3  N4  SO  CG CC CV');
END;
 begin
 clrscr;
 assign(arq2,'CADAST.dir');
 CABECA;
 reset(arq2);
  while not(eof(arq2)) do
  begin
   read(arq2,reg2);
   
   //
	 if(reg2.num<>0)then {tire este if-- e veja o que acontece}
   
    begin
     t:=t+1;
     writeln(t:5,reg2.num:5,' ',REG2.NOME,' ',reg2.cpf,' ',copy(reg2.data,7,2),'/',copy(reg2
     .data,5,2),'/',copy(reg2.data,1,4),reg2.car:3,reg2.n1:4,reg2.n2:4,REG2.N3:4
     ,REG2.N4:4,reg2.so:4,reg2.clg:4,reg2.clc:3,reg2.ccl:3 );
     if(t MOD 50 = 0)THEN
      BEGIN
       readln;
       CABECA;
     end;
    END;
  end;
  close(arq2);
  writeln('lidos=',t:5);
  readln;
end.