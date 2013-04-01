
/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[A-Za-z]\w*	      return 'ID'
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"!"                   return '!'
"%"                   return '%'
"("                   return '('
")"                   return ')'
"PI"                  return 'PI'
"E"                   return 'E'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%right '!'
%right '%'
%left UMINUS

%start expressions

%% /* language grammar */

//devolvemos $$ y symbol_table

//producción de S -> expressions EOF      {$$ = $1? [$1] : [];}
//                | expressions ';' S
                    $$ = $1; if ($3) $$.push($3); console.log($$)

expressions
    : e EOF  //return [$$, symbol_table] es lo q devuelv eal final 
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return $1; }
    ;

e
    : ID '=' e    //(PI -> e //throw error | E -> e //throw error)  throw new Error ("balblabal");
	{ symbol_table[$1] = $$ = $3; }  // { symbol_table[$ID] = $$ = $e; }
    | e '+' e
        {$$ = $1+$3;}  // $e1+$e2
    | e '-' e
        {$$ = $1-$3;}
    | e '*' e
        {$$ = $1*$3;}
    | e '/' e
        {$$ = $1/$3;} //if $3 == 0, throw new error
    | e '^' e
        {$$ = Math.pow($1, $3);}
    | e '!'
        {{
          $$ = (function fact (n) { return n==0 ? 1 : fact(n-1) * n })($1);
        }}
    | e '%'
        {$$ = $1/100;}
    | '-' e %prec UMINUS
        {$$ = -$2;}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number(yytext);}
    | E
        {$$ = Math.E;}
    | PI
        {$$ = Math.PI;}
    | ID
	{ $$ = symbol_table[$ID]; }
    ;

