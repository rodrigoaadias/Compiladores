/****************************************************/
/* File: util.c                                     */
/* Utility function implementation                  */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "util.h"

/* Procedure printToken prints a token
 * and its lexeme to the listing file
 */
void printToken(TokenType token, const char *tokenString)
{
    switch (token)
    {
    case IF:
    case ELSE:
    case INT:
    case RETURN:
    case VOID:
    case WHILE:
        fprintf(listing,
                "reserved word: %s\n", tokenString);
        break;

    case SOM:
        fprintf(listing, "+\n");
        break;
    case SUB:
        fprintf(listing, "-\n");
        break;
    case MUL:
        fprintf(listing, "*\n");
        break;
    case DIV:
        fprintf(listing, "/\n");
        break;
    case MENOR:
        fprintf(listing, "<\n");
        break;
    case MENORIGUAL:
        fprintf(listing, "<=\n");
        break;
    case MAIOR:
        fprintf(listing, ">\n");
        break;
    case MAIORIGUAL:
        fprintf(listing, ">=\n");
        break;
    case EQ:
        fprintf(listing, "==\n");
        break;
    case NEQ:
        fprintf(listing, "!=\n");
        break;
    case ASSIGN:
        fprintf(listing, "=\n");
        break;
    case PEV:
        fprintf(listing, ";\n");
        break;
    case VIRG:
        fprintf(listing, ",\n");
        break;
    case APR:
        fprintf(listing, "(\n");
        break;
    case FPR:
        fprintf(listing, ")\n");
        break;
    case ACOL:
        fprintf(listing, "[\n");
        break;
    case FCOL:
        fprintf(listing, "]\n");
        break;
    case ACH:
        fprintf(listing, "{\n");
        break;
    case FCH:
        fprintf(listing, "}\n");
        break;
    case ENDFILE:
        fprintf(listing, "%s %s\n", "ENDFILE", "EOF");
        break;
    case NUM:
        fprintf(listing, "NUM, val = %s\n", tokenString);
        break;
    case ID:
        fprintf(listing, "ID, name = %s\n", tokenString);
        break;
    case ERROR:
        fprintf(listing, "ERROR: %s\n", tokenString);
        break;
    default: /* should never happen */
        fprintf(listing, "Unknown token: %d with token string: $s\n", token, tokenString);
    }
}

/* atribuicao do escopo em nos da arvore */
void aggScope(TreeNode *t, char *scope)
{
    int i;
    while (t != NULL)
    {
        for (i = 0; i < MAXCHILDREN; ++i)
        {
            t->attr.scope = scope;
            aggScope(t->child[i], scope);
        }
        t = t->sibling;
    }
}

/* Function newStmtNode creates a new statement
 * node for syntax tree construction
 */
TreeNode *newStmtNode(StmtKind kind)
{
    TreeNode *t = (TreeNode *)malloc(sizeof(TreeNode));
    int i;
    if (t == NULL)
        fprintf(listing, "Out of memory error at line %d\n", lineno);
    else
    {
        for (i = 0; i < MAXCHILDREN; i++)
            t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = StmtK;
        t->kind.stmt = kind;
        t->lineno = lineno;
        t->attr.scope = "global";
    }
    return t;
}

/* Function newExpNode creates a new expression
 * node for syntax tree construction
 */
TreeNode *newExpNode(ExpKind kind)
{
    TreeNode *t = (TreeNode *)malloc(sizeof(TreeNode));
    int i;
    if (t == NULL)
        fprintf(listing, "Out of memory error at line %d\n", lineno);
    else
    {
        for (i = 0; i < MAXCHILDREN; i++)
            t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = ExpK;
        t->kind.exp = kind;
        t->lineno = lineno;
        t->type = VOID;
        t->attr.scope = "global";
    }
    return t;
}

/* Function copyString allocates and makes a new
 * copy of an existing string
 */
char *copyString(char *s)
{
    int n;
    char *t;
    if (s == NULL)
        return NULL;
    n = strlen(s) + 1;
    t = malloc(n);
    if (t == NULL)
        fprintf(listing, "Out of memory error at line %d\n", lineno);
    else
        strcpy(t, s);
    return t;
}

/* Variable indentno is used by printTree to
 * store current number of spaces to indent
 */
static indentno = 0;

/* macros to increase/decrease indentation */
#define INDENT indentno += 2
#define UNINDENT indentno -= 2

/* printSpaces indents by printing spaces */
static void printSpaces(void)
{
    int i;
    for (i = 0; i < indentno; i++)
        fprintf(listing, " ");
}

/* procedure printTree prints a syntax tree to the
 * listing file using indentation to indicate subtrees
 */
void printTree(TreeNode *tree)
{
    int i;
    INDENT;
    while (tree != NULL)
    {
        printSpaces();
        if (tree->nodekind == StmtK)
        {
            switch (tree->kind.stmt)
            {
            case IfK:
                fprintf(listing, "If\n");
                break;
            case AssignK:
                fprintf(listing, "Assignment\n");
                break;
            case WhileK:
                fprintf(listing, "While\n");
                break;
            case VariableK:
                fprintf(listing, "Variable %s\n", tree->attr.name);
                break;
            case FunctionK:
                fprintf(listing, "Function %s\n", tree->attr.name);
                break;
            case CallK:
                fprintf(listing, "Function call %s \n", tree->attr.name);
                break;
            case ReturnK:
                fprintf(listing, "Return\n");
                break;

            default:
                fprintf(listing, "Unknown expression no\n");
                break;
            }
        }
        else if (tree->nodekind == ExpK)
        {
            switch (tree->kind.exp)
            {
            case OpK:
                fprintf(listing, "Operation: ");
                printToken(tree->attr.op, "\0");
                break;
            case ConstK:
                fprintf(listing, "Constant: %d\n", tree->attr.val);
                break;
            case IdK:
                fprintf(listing, "Id: %s\n", tree->attr.name);
                break;
            case VectorK:
                fprintf(listing, "Array: %s\n", tree->attr.name);
                break;
            case VectorIdK:
                fprintf(listing, "Index [%d]\n", tree->attr.val);
                break;
            case TypeK:
                fprintf(listing, "Type %s\n", tree->attr.name);
                break;

            default:
                fprintf(listing, "Unknown expression no\n");
                break;
            }
        }
        else
            fprintf(listing, "Unknown expression no\n");
        for (i = 0; i < MAXCHILDREN; i++)
            printTree(tree->child[i]);
        tree = tree->sibling;
    }
    UNINDENT;
}
