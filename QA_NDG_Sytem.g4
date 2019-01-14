/*
 * Linguagem: "Sociedade Anonima"
 * Processador: Gramatica Independente de Contexto que permite descrever um conjunto de produtos Nescaf� Dolce Gusto 
 * CP, TS 2019.01.09
 */


grammar QA_NDG_Sytem;

@header{
        import java.util.*;
}

@members{
          class Produto{
                String nome;
                String tipo;
                int quantidade;
                int n_capsulas;
                int intensidade;
                String torra;
                int cafeina;
                ArrayList <String> origem;
                ArrayList <String> origemP;
           
           public Produto () {
                this.nome = null; 
                this.tipo = null;
                this.quantidade = 0;
                this.n_capsulas = 0;
                this.intensidade = 0;
                this.torra = null;
                this.cafeina = 0;
                this.origem = new ArrayList<String>();
                this.origemP = new ArrayList<String>();
           }
           
           public Produto (String nome, String tipo, int quantidade, int n_capsulas, int intensidade, String torra, int cafeina,  ArrayList <String> origem, ArrayList <String> origemP) {
                this.nome = nome;
                this.tipo = tipo;
                this.quantidade = quantidade;
                this.n_capsulas = n_capsulas;
                this.intensidade = intensidade;
                this.torra = torra;
                this.cafeina = cafeina;
                this.origem = origem;
                this.origemP = origemP;
           }
           
           public void setNome (String nome) {
                this.nome=nome;
           }
           
           public void setTipo (String tipo) {
                this.tipo=tipo;
           }
           
           public void setQuantidade (int quantidade) {
                this.quantidade=quantidade;
           }
           
           public void setN_capsulas (int n_capsulas) {
                this.n_capsulas=n_capsulas;
           }

           public void setIntensidade (int intensidade) {
                this.intensidade=intensidade;
           }

           public void setTorra (String torra) {
                this.torra=torra;
           }

           public void setCafeina (int cafeina) {
                this.cafeina=cafeina;
           }
           
           public void setOrigem (ArrayList<String> origem) {
                for (String i: origem)
                    this.origem.add(i);
           }
           
           public void setOrigemP (ArrayList<String> origemP) {
                for (String i: origemP)
                    this.origemP.add(i);
           }           
           
           public String getName () {
                return(this.nome);
           }
           
           public String toString(){
                 StringBuffer sb = new StringBuffer();
                 sb.append(this.nome+"; ");
                 sb.append(this.tipo+"; ");
                 sb.append(this.quantidade+" ml; ");
                 sb.append(this.n_capsulas+" cápsulas; ");
                 sb.append(this.intensidade+" de intensidade; ");
                 sb.append(this.torra+"; ");
                 sb.append(this.cafeina+" mg/porção; ");
                 for(String i: this.origem) {
                    sb.append(i+", ");
                 }
                 sb.append("; ");   
                 for(String i: this.origemP) {
                    sb.append(i+", ");
                 }
                 sb.append(". ");   
                 return sb.toString();   
           } 
    }
}
sistema         returns [HashMap <String,Produto> produtos]
@init {
       $sistema.produtos = new HashMap<String,Produto>();
      }
                :(base_conhecimento {$sistema.produtos.put($base_conhecimento.produto.getName(),$base_conhecimento.produto);})+ '.'
                '---' (perguntas [$sistema.produtos])+ 
                ;

base_conhecimento returns [Produto produto] 
@init {
       $base_conhecimento.produto = new Produto();
}   
                 : '(' nome {$base_conhecimento.produto.setNome($nome.text);}
                    ',' tipo  {$base_conhecimento.produto.setTipo($tipo.text);} 
                    ',' quantidade  {$base_conhecimento.produto.setQuantidade($quantidade.quant);}
                    ',' n_capsulas  {$base_conhecimento.produto.setN_capsulas($n_capsulas.num);}
                    (',' intensidade)?  {if(!($intensidade.text==null))$base_conhecimento.produto.setIntensidade($intensidade.num);}
                    (',' torra)?  {if(!($torra.text == null))$base_conhecimento.produto.setTorra($torra.text);}
                    (',' cafeina)?  {if(!($cafeina.text == null))$base_conhecimento.produto.setCafeina($cafeina.num);}
                    (',' origem)?  {if (!($origem.text == null))$base_conhecimento.produto.setOrigem($origem.origens);}
                    (',' origemP)? {if (!($origemP.text == null)) $base_conhecimento.produto.setOrigemP($origemP.paises);} 
                    ')'
                 ;
nome        : TEXTO
            ;

tipo        : TEXTO
            ;

quantidade  returns [int quant]
            : NUMERO{$quantidade.quant=$NUMERO.int;}
            ;

n_capsulas  returns [int num]
            : NUMERO{$n_capsulas.num=$NUMERO.int;}
            ;

intensidade returns [int num]
@init {
       $intensidade.num=0;
}
            : NUMERO{$intensidade.num=$NUMERO.int;}
            ;

torra       : TEXTO
            ;

cafeina     returns [int num]
@init {
       $cafeina.num=0;
}
            : NUMERO{$cafeina.num=$NUMERO.int;} 'mg'
            ;

origem      returns [ArrayList<String> origens]
@init {
       $origem.origens = new ArrayList<String>();
       }
            : '(' c1=cafe {$origem.origens.add($c1.text);}
              (',' c2=cafe {$origem.origens.add($c2.text);}
              )* ')'
            ;

cafe        : TEXTO
            ;

origemP     returns [ArrayList<String> paises]
@init {
       $origemP.paises = new ArrayList<String>();
       }
            : '(' p1=pais {$origemP.paises.add($p1.text);}
              (',' p2=pais {$origemP.paises.add($p2.text);}
              )* ')'
            ;

pais        : TEXTO
            ;
        
  
 /* Perguntas */

perguntas [HashMap<String, Produto> produtos]
          returns [int tipoQ, boolean ok, ArrayList<String> querie]
    @init{
        $perguntas.ok=true;
        $perguntas.querie = new ArrayList <String> ();
        $perguntas.querie.add("\"quantidade\""); $perguntas.querie.add("\"número de cápsulas\"");
        $perguntas.querie.add("\"intensidade\""); $perguntas.querie.add("\"torra\"");
        $perguntas.querie.add("\"cafeína\""); $perguntas.querie.add("\"origem\"");
        $perguntas.querie.add("\"país de origem\""); $perguntas.querie.add("\"tipo de bebida\"");
        $perguntas.querie.add("\"listar\"");
        String o1Obj = null;
        HashMap <String, String> todos = new HashMap<>();
        String produtoUnico = "";
        String origemTodos = "";
    }
          : '(' tipo_Q{if(!$tipo_Q.ok){ System.out.println("O tipo de questão introduzido é inválido."); $perguntas.ok=false;}
                       else {$perguntas.tipoQ=$tipo_Q.tipoQ;}} 
          ',' '[' o1=operacao[$perguntas.ok, $perguntas.querie, $perguntas.produtos]
                  {
                    if($o1.existe){
                        o1Obj = $o1.objText;
                        switch($o1.queryAux) {
                            case "\"quantidade\"":
                                if($o1.operadorAux == null){
                                    if($o1.objText.contains("todos")){
                                        for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {todos.put(produto.getKey(), " -> A quantidade é: " + produto.getValue().quantidade + "ml.");}
                                    }
                                    else{
                                         produtoUnico += "A quantidade é: " + $perguntas.produtos.get($o1.objText).quantidade + "ml.";
                                    }
                                }
                                else{
                                    if($o1.textOp == null){
                                        if($o1.objText.contains("todos")){
                                            switch($o1.operadorAux){
                                                case "<":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().quantidade < $o1.numOp){
                                                            todos.put(produto.getKey(), " -> A quantidade é: " + produto.getValue().quantidade + "ml.");
                                                        }
                                                    }
                                                break;
                                                case ">":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().quantidade > $o1.numOp){
                                                            todos.put(produto.getKey(), " -> A quantidade é: " + produto.getValue().quantidade + "ml.");
                                                        }
                                                    }
                                                break;
                                                case "=":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().quantidade == $o1.numOp){
                                                            todos.put(produto.getKey(), " -> A quantidade é: " + produto.getValue().quantidade + "ml.");
                                                        }
                                                    }
                                                break;
                                                default:
                                                    System.out.println("Erro");
                                                    break;
                                            }
                                        }
                                        else{
                                            System.out.println("Análise de dados com operadores apenas é efetuada a todos os produtos.");
                                        }
                                    }
                                }
                                break;
                            case "\"número de cápsulas\"":
                                if($o1.operadorAux == null){
                                    if($o1.objText.contains("todos")){
                                        for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {todos.put(produto.getKey(), " -> O número de cápsulas é: " + produto.getValue().n_capsulas + ".");}
                                    }
                                    else{
                                         produtoUnico += "O número de cápsulas é: " + $perguntas.produtos.get($o1.objText).n_capsulas + " cápsulas.";
                                    }
                                }
                                else{
                                    if($o1.textOp == null){
                                        if($o1.objText.contains("todos")){
                                            switch($o1.operadorAux){
                                                case "<":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().n_capsulas < $o1.numOp){
                                                            todos.put(produto.getKey(), " -> O número de cápsulas é: " + produto.getValue().n_capsulas + ".");
                                                        }
                                                    }
                                                break;
                                                case ">":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().n_capsulas > $o1.numOp){
                                                            todos.put(produto.getKey(), " -> O número de cápsulas é: " + produto.getValue().n_capsulas + ".");
                                                        }
                                                    }
                                                break;
                                                case "=":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().n_capsulas == $o1.numOp){
                                                            todos.put(produto.getKey(), " -> O número de cápsulas é: " + produto.getValue().n_capsulas + ".");
                                                        }
                                                    }
                                                break;
                                                default:
                                                    System.out.println("Erro");
                                                    break;
                                            }
                                        }
                                        else{
                                            System.out.println("Análise de dados com operadores apenas é efetuada a todos os produtos.");
                                        }
                                    }
                                }
                                break;
                            case "\"intensidade\"":
                                if($o1.operadorAux == null){
                                    if($o1.objText.contains("todos")){
                                        for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {todos.put(produto.getKey(), " -> A intensidade é: " + produto.getValue().intensidade + ".");}
                                    }
                                    else{
                                         produtoUnico += "A intensidade é: " + $perguntas.produtos.get($o1.objText).intensidade + ".";
                                    }
                                }
                                else{
                                    if($o1.textOp == null){
                                        if($o1.objText.contains("todos")){
                                            switch($o1.operadorAux){
                                                case "<":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().intensidade < $o1.numOp){
                                                            todos.put(produto.getKey(), " -> A intensidade é: " + produto.getValue().intensidade + ".");
                                                        }
                                                    }
                                                break;
                                                case ">":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().intensidade > $o1.numOp){
                                                            todos.put(produto.getKey(), " -> A intensidade é: " + produto.getValue().intensidade + ".");
                                                        }
                                                    }
                                                break;
                                                case "=":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().intensidade == $o1.numOp){
                                                            todos.put(produto.getKey(), " -> A intensidade é: " + produto.getValue().intensidade + ".");
                                                        }
                                                    }
                                                break;
                                                default:
                                                    System.out.println("Erro");
                                                    break;
                                            }
                                        }
                                        else{
                                            System.out.println("Análise de dados com operadores apenas é efetuada a todos os produtos.");
                                        }
                                    }
                                }
                                break;
                            case "\"torra\"":
                                if($o1.operadorAux == null){
                                    if($o1.objText.contains("todos")){
                                        for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {todos.put(produto.getKey(), " -> O tipo de torra é: " + produto.getValue().torra + ".");}
                                    }
                                    else{
                                         produtoUnico += "O tipo de torra é: " + $perguntas.produtos.get($o1.objText).torra + ".";
                                    }
                                }
                                else{
                                    if($o1.operadorAux.contains("contém")){
                                        if($o1.objText.contains("todos")){
                                            for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if((produto.getValue().torra!=null) && (produto.getValue().torra.contains($o1.textOp))){
                                                            todos.put(produto.getKey(), " -> O tipo de torra é: " + produto.getValue().torra + ".");
                                                            System.out.println(produto.getKey() + " -> O tipo de torra é: " + produto.getValue().torra + ".");
                                                        }
                                            }
                                        }
                                        else{
                                            System.out.println("Análise de dados com operadores apenas é efetuada a todos os produtos.");
                                        }
                                    }
                                    else{
                                        {System.out.println("Erro");}
                                    }
                                }
                                break;
                            case "\"cafeína\"":
                                if($o1.operadorAux == null){
                                    if($o1.objText.contains("todos")){
                                        for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {todos.put(produto.getKey(), " -> A quantidade de cafeína é: " + produto.getValue().cafeina + "mg/porção.");}
                                    }
                                    else{
                                         produtoUnico += "A quantidade de cafeína é: " + $perguntas.produtos.get($o1.objText).cafeina + "mg/porção.";
                                    }
                                }
                                else{
                                    if($o1.textOp == null){
                                        if($o1.objText.contains("todos")){
                                            switch($o1.operadorAux){
                                                case "<":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().cafeina < $o1.numOp){
                                                            todos.put(produto.getKey(), " -> A quantidade de cafeína é: " + produto.getValue().cafeina + "mg/porção.");
                                                        }
                                                    }
                                                break;
                                                case ">":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().cafeina > $o1.numOp){
                                                            todos.put(produto.getKey(), " -> A quantidade de cafeína é: " + produto.getValue().cafeina + "mg/porção.");
                                                        }
                                                    }
                                                break;
                                                case "=":
                                                    for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if(produto.getValue().cafeina == $o1.numOp){
                                                            todos.put(produto.getKey(), " -> A quantidade de cafeína é: " + produto.getValue().cafeina + "mg/porção.");
                                                        }
                                                    }
                                                break;
                                                default:
                                                    System.out.println("Erro");
                                                    break;
                                            }
                                        }
                                        else{
                                            System.out.println("Análise de dados com operadores apenas é efetuada a todos os produtos.");
                                        }
                                    }
                                }
                                break;
                            case "\"origem\"":
                                if($o1.operadorAux == null){
                                    if($o1.objText.contains("todos")){
                                        for (Map.Entry<String, Produto> produto : $perguntas.produtos.entrySet()) {
                                            if((!produto.getValue().origem.isEmpty())){
                                                int i;
                                                for (i = 0; i < (produto.getValue().origem.size()-1); i++) {
                                                    origemTodos += produto.getValue().origem.get(i) + ", ";
                                                }
                                                origemTodos += produto.getValue().origem.get(i) + ".";
                                                todos.put(produto.getKey(), " -> Origem: " + origemTodos);
                                            }
                                            else {todos.put(produto.getKey(), " -> Origem: não tem origem");
                                            }
                                            origemTodos = "";
                                        }
                                    }
                                    else{
                                         if((!$perguntas.produtos.get($o1.objText).origem.isEmpty())){
                                            produtoUnico += "A origem é: ";
                                            int i;
                                            for (i = 0; i < ($perguntas.produtos.get($o1.objText).origem.size()-1); i++) {
                                                produtoUnico += $perguntas.produtos.get($o1.objText).origem.get(i) + ", ";
                                            }
                                            produtoUnico += $perguntas.produtos.get($o1.objText).origem.get(i) + ".";
                                         }
                                         else {produtoUnico += "Não tem origem.";}
                                    }
                                }
                                else{
                                    if($o1.operadorAux.contains("contém")){
                                        if($o1.objText.contains("todos")){
                                            for (Map.Entry<String, Produto> produto : $perguntas.produtos.entrySet()) {
                                                if((!produto.getValue().origem.isEmpty()) && (produto.getValue().origem.contains($o1.textOp))){
                                                    int i;
                                                    for (i = 0; i < (produto.getValue().origem.size()-1); i++) {
                                                        origemTodos += produto.getValue().origem.get(i) + ", ";
                                                    }
                                                    origemTodos += produto.getValue().origem.get(i) + ".";
                                                    todos.put(produto.getKey(), " -> Origem: " + origemTodos);
                                                }
                                                origemTodos = "";
                                            }
                                        }
                                        else{
                                            System.out.println("Análise de dados com operadores apenas é efetuada a todos os produtos.");
                                        }
                                    }
                                    else{
                                        {System.out.println("Erro");}
                                    }
                                }
                                break;
                            case "\"país de origem\"":
                                if($o1.operadorAux == null){
                                    if($o1.objText.contains("todos")){
                                        for (Map.Entry<String, Produto> produto : $perguntas.produtos.entrySet()) {
                                            if((!produto.getValue().origemP.isEmpty())){
                                                int i;
                                                for (i = 0; i < (produto.getValue().origemP.size()-1); i++) {
                                                    origemTodos += produto.getValue().origemP.get(i) + ", ";
                                                }
                                                origemTodos += produto.getValue().origemP.get(i) + ".";
                                                todos.put(produto.getKey(), " -> País de origem: " + origemTodos);
                                            }
                                            else {todos.put(produto.getKey(), " -> País de origem: não tem país de origem.");
                                            }
                                            origemTodos = "";
                                        }
                                    }
                                    else{
                                         if((!$perguntas.produtos.get($o1.objText).origemP.isEmpty())){
                                            produtoUnico += "O país de origem é: ";
                                            int i;
                                            for (i = 0; i < ($perguntas.produtos.get($o1.objText).origemP.size()-1); i++) {
                                                produtoUnico += $perguntas.produtos.get($o1.objText).origemP.get(i) + ", ";
                                            }
                                            produtoUnico += $perguntas.produtos.get($o1.objText).origemP.get(i) + ".";
                                         }
                                         else {produtoUnico += "Não tem país de origem.";}
                                    }
                                }
                                else{
                                    if($o1.operadorAux.contains("contém")){
                                        if($o1.objText.contains("todos")){
                                            for (Map.Entry<String, Produto> produto : $perguntas.produtos.entrySet()) {
                                                if((!produto.getValue().origemP.isEmpty()) && (produto.getValue().origemP.contains($o1.textOp))){
                                                    int i;
                                                    for (i = 0; i < (produto.getValue().origemP.size()-1); i++) {
                                                        origemTodos += produto.getValue().origemP.get(i) + ", ";
                                                    }
                                                    origemTodos += produto.getValue().origemP.get(i) + ".";
                                                    todos.put(produto.getKey(), " -> País de origem: " + origemTodos);
                                                }
                                                origemTodos = "";
                                            }
                                        }
                                        else{
                                            System.out.println("Análise de dados com operadores apenas é efetuada a todos os produtos.");
                                        }
                                    }
                                    else{
                                        {System.out.println("Erro");}
                                    }
                                }
                                break;
                            case "\"tipo de bebida\"":
                                if($o1.operadorAux == null){
                                    if($o1.objText.contains("todos")){
                                        for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {todos.put(produto.getKey(), " -> O tipo de bebida é: " + produto.getValue().tipo + ".");}
                                    }
                                    else{
                                         produtoUnico += " O tipo de bebida é: " + $perguntas.produtos.get($o1.objText).tipo + ".";
                                    }
                                }
                                else{
                                    if($o1.operadorAux.contains("contém")){
                                        if($o1.objText.contains("todos")){
                                            for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {
                                                        if((produto.getValue().tipo!=null) && (produto.getValue().tipo.contains($o1.textOp))){
                                                            todos.put(produto.getKey(), " -> O tipo de bebida é:: " + produto.getValue().tipo + ".");
                                                            System.out.println(produto.getKey() + " -> O tipo de bebida é:: " + produto.getValue().tipo + ".");
                                                        }
                                            }
                                        }
                                        else{
                                            System.out.println("Análise de dados com operadores apenas é efetuada a todos os produtos.");
                                        }
                                    }
                                    else{
                                        {System.out.println("Erro");}
                                    }
                                }
                                break;
                            case "\"listar\"":
                                {for (Map.Entry<String, Produto>produto : $perguntas.produtos.entrySet()) {Produto p = produto.getValue(); System.out.println(p.toString());}}
                                break;
                        }
                }
          }
          (','{if($perguntas.tipoQ==2){$perguntas.ok=false; System.out.println("O número de operações introduzidas, não está de acordo com o tipo de pergunta.");}}
          (o2=operacao[$perguntas.ok, $perguntas.querie, $perguntas.produtos])
            {if(o1Obj.contains($o2.objText)){;}
             else{System.out.println("As perguntas têm de ser relativas ao mesmo objeto.");}}
          )* ']' ')' '.'
          ;

tipo_Q    returns [boolean ok, int tipoQ]
    @init{
                boolean ok = false;
          }
          : 'Quantos' {$tipo_Q.ok = true; $tipo_Q.tipoQ=1;}
          | 'Qual' {$tipo_Q.ok = true; $tipo_Q.tipoQ=2;}
          | 'Quais' {$tipo_Q.ok = true; $tipo_Q.tipoQ=3;}
          ;

operacao [boolean ok, ArrayList<String> queries, HashMap<String, Produto> produtos]
         returns [String objText, String queryAux, String operadorAux, String textOp, int numOp, boolean existe]
    @init{
          $operacao.existe = true;
          $operacao.textOp = null;
          $operacao.numOp = -1;
          }
         : '(' acao{   if($operacao.ok && $operacao.queries.contains($acao.queryAux)){
                            if($acao.valido){
                                $operacao.queryAux = $acao.queryAux; $operacao.operadorAux = $acao.operadorAux;
                                if($acao.textOp!=null){$operacao.textOp = $acao.textOp;}
                                else{$operacao.numOp = $acao.numOp;}
                            }
                            else{$operacao.existe = false;}
                        }
                        else{System.out.println("Query inválida"); $operacao.existe = false;}
                    }
           ',' objeto {if($operacao.existe){
                            if($operacao.produtos.containsKey($objeto.objText) || $objeto.objText.contains("todos")){
                                $operacao.objText = $objeto.objText;
                            }
                        }
                      } ')'
         ;

acao     returns [String queryAux, String operadorAux, int numOp, String textOp, boolean valido]
    @init{
          $acao.operadorAux = null;
          $acao.valido = true;
          $acao.textOp = null;
          $acao.numOp = -1;
         }
         : query{$acao.queryAux = $query.text;}
           (',' operador{if($operador.operadorAux != null){$acao.operadorAux = $operador.operadorAux;}
                         else{System.out.println("Query inválida: Operador inválido");$acao.valido = false;}}
            ','  operando{if($acao.valido){
                          if(($operando.numOp == -1) && ($acao.operadorAux.contains("contém"))){$acao.textOp = $operando.textOp;}
                          else if(($acao.operadorAux!=null) && ($operando.numOp >= 0)){$acao.numOp = $operando.numOp;}
                          else{System.out.println("Query inválida: Operando não estão em conformidade com o Operador"); $acao.valido = false;}}}
           )?
         ;

query    : TEXTO
         ;

operador returns [String operadorAux]
    @init{
          $operador.operadorAux = null;
         }
         : '=' {$operador.operadorAux = "=";}
         | '<' {$operador.operadorAux = "<";}
         | '>' {$operador.operadorAux = ">";}
         | CONTEM {$operador.operadorAux = "contém";}
         ;

operando returns [int numOp, String textOp]
    @init{
          $operando.numOp = -1;
          $operando.textOp = null;
         }
         : TEXTO {$operando.textOp = $TEXTO.text;}
         | NUMERO {$operando.numOp = $NUMERO.int;}
         ;

objeto   returns [String objText]
@init{
      $objeto.objText = null;
     }
         : TEXTO {$objeto.objText = $TEXTO.text;}
         | TODOS {$objeto.objText = "todos";}
         ;


     /* Definicao do Analisador LEXICO */

TEXTO:    (('\''|'\"') ~('\''|'\"')* ('\''|'\"')) ; 

TODOS: [Tt][Oo][Dd][Oo][Ss];

CONTEM: [Cc][Oo][Nn][Tt][ÉéEe][Mm];

NUMERO: ('0'..'9')+ ; // [0-9]+

Separador: ('\r'? '\n' | ' ' | '\t')+  -> skip;
