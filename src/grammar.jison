/* Lexer */
%lex
%%
\s+                                 { /* saltar espacios */ }
"//".*                              { /* skip single line comments */; }
[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)? { return 'NUMBER'; }
"**"                                { return 'opow'; } 
"*"                                 { return 'opmu'; }
"/"                                 { return 'opmu'; }
"+"                                 { return 'opad'; }
"-"                                 { return 'opad'; }
<<EOF>>                             { return 'EOF'; }
.                                   { return 'INVALID'; }
/lex

// Presedencia, cuanto mas arriba esté, menor precedencia tiene. 
%start expressions
%token NUMBER opad opmu opow
%%

expressions
    : expression EOF
        { return $1; }
    ;

/* Sumas y Restas */
expression
    : expression opad term
        { $$ = operate($2, $1, $3); }
    | term
        { $$ = $1; }
    ;

/* Multiplicaciones y Divisiones */
term
    : term opmu factor
        { $$ = operate($2, $1, $3); }
    | factor
        { $$ = $1; } //Si no hay suma pasa a la sigiente.
    ;

/* Potencia  */
/* Al poner 'factor' a la derecha, Jison lo hace asociativo por la derecha */
factor
    : primary opow factor
        { $$ = Math.pow($1, $3); }
    | primary
        { $$ = $1; }
    ;

/* Números */
primary
    : NUMBER
        { $$ = Number(yytext); }
    ;

%%

function operate(op, left, right) {
    switch (op) {
        case '+': return left + right;
        case '-': return left - right;
        case '*': return left * right;
        case '/': return left / right;
        case '**': return Math.pow(left, right);
    }
}