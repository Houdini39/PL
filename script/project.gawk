#!/usr/bin/gawk -f

BEGIN {
  enc = "<html> <head> <meta charset='UTF-8'/> </head> <body>"
  list_begin = "<li> "
  list_end = " </li>\n"
  par_begin = "<p> "
  par_end = " </p>\n"
  head1 = "<h1> %s </h1>\n"
  head3 = "<h3> %s </h3>\n"
  head2 = "<h2> %s: %s </h2>\n"
  bold = "<b> %s </b>"
  div = "<hr></hr>"
  end = "</body> </html>"
  custo = 0.0
  custoParque = 0.0
  valorImportancia = 0.0
}

match($0,"<DATA_ENTRADA>(.*)</DATA_ENTRADA>", d){
	if(d[1] == "null")
		d[1] = "Não registado"
	dias[d[1]]++
	impData[d[1]] += valorImportancia
}

match($0, "<ENTRADA>(.*)</ENTRADA>", ent){
	entradas[ent[1]]
}

match($0,"<SAIDA>(.*)</SAIDA>", loc){
	listaL[loc[1]]
}

match($0,"<IMPORTANCIA>(.*)</IMPORTANCIA>", importancia){
  sub(/,/,".",importancia[1])
  custo += importancia[1]
  valorImportancia = importancia[1]
}

/Parques de estacionamento/{
  custoParque += valorImportancia
}

/MES_EMISSAO/{
	mes = $1
}


match($0, "<NOME>(.*)</NOME>", n){
	nome = n[1]
}

match($0, "<MORADA>(.*)</MORADA", m){
	morada = m[1]
}

match($0, "<MATRICULA>(.*)</MATRICULA>", mt){
	matricula = mt[1]
}

match($0, "<LOCALIDADE>(.*)</LOCALIDADE>", l){
	localidade = l[1]
}

match($0, "<CODIGO_POSTAL>(.*)</CODIGO_POSTAL>", cp){
	codigop = cp[1]
}


END {
  print enc > "index.html"

  printf(head1, "Transações da Via Verde") > "index.html"

  printf(par_begin bold "%s" par_end, "Emitido em: ", mes) > "index.html"

  print div > "index.html"

  printf(par_begin bold "%s" par_end, "Nome: ", nome) > "index.html"
  printf(par_begin bold "%s" par_end, "Morada: ", morada) > "index.html"
  printf(par_begin bold "%s" par_end, "Localidade: ", localidade) > "index.html"
  printf(par_begin bold "%s" par_end, "Código Postal: ", codigop) > "index.html"
  printf(par_begin bold "%s" par_end, "Matrícula: ", matricula) > "index.html"

  print div > "index.html"

  printf(head3, "Número de entradas por dia") > "index.html"
  for (dia in dias) printf (list_begin "%s: %d" list_end, dia, dias[dia]) > "index.html"

  print div > "index.html"

  printf(head3, "Custo total por dia") > "index.html"
  for (data in impData) printf (list_begin "%s: %.2f €" list_end, data, impData[data]) > "index.html"

  print div > "index.html"

  printf(head3, "Lista de locais de entrada") > "index.html"
  for (e in entradas) printf (list_begin "%s" list_end, e) > "index.html"

  print div > "index.html"

  printf(head3, "Lista de locais de saída") > "index.html"
  for (local in listaL) printf (list_begin "%s" list_end, local) > "index.html"

  print div > "index.html"

  printf(head3, "Custo total do mês") > "index.html"
  printf(par_begin "%s: %.2f €" par_end, "Total", custo) > "index.html"

  print div > "index.html"

  printf(head3, "Total gasto em parques") > "index.html"
  printf(par_begin "%s: %.2f €" par_end, "Total", custoParque) > "index.html"

  print end > "index.html"
}