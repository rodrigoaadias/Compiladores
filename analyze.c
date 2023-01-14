/****************************************************/
/* File: analyze.c                                  */
/* Semantic analyzer implementation                 */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "symtab.h"
#include "analyze.h"

static void typeError(TreeNode *t, char *message)
{
    fprintf(listing, "Type error in %s on line %d: %s\n", t->attr.name, t->lineno, message);
    Error = TRUE;
}

/* counter for variable memory locations */
static int location = 0;

/* Procedure traverse is a generic recursive
 * syntax tree traversal routine:
 * it applies preProc in preorder and postProc
 * in postorder to tree pointed to by t
 */
static void traverse(TreeNode *t,
                     void (*preProc)(TreeNode *),
                     void (*postProc)(TreeNode *))
{
    if (t != NULL)
    {
        preProc(t);
        {
            int i;
            for (i = 0; i < MAXCHILDREN; i++)
                traverse(t->child[i], preProc, postProc);
        }
        postProc(t);
        traverse(t->sibling, preProc, postProc);
    }
}

/* nullProc is a do-nothing procedure to
 * generate preorder-only or postorder-only
 * traversals from traverse
 */
static void nullProc(TreeNode *t)
{
    if (t == NULL)
        return;
    else
        return;
}

/* Procedure insertNode inserts
 * identifiers stored in t into
 * the symbol table
 */
static void insertNode(TreeNode *t)
{
    switch (t->nodekind)
    {
    case StmtK:
        switch (t->kind.stmt)
        {
        case VariableK:
            if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1)
            {
                if (t->attr.len > 0) // declaracao de vetor
                    st_insert(t->attr.name, t->lineno, location++, t->attr.scope, "array", "integer");
                else // declaracao de variavel simples
                    st_insert(t->attr.name, t->lineno, location++, t->attr.scope, "variable", "integer");
            }
            else
                typeError(t, "Error 4: Invalid declaration. Already declared.");
            break;
        case FunctionK:
            if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1)
            {
                if (t->type == IntegerK)
                {
                    /* not yet in table, so treat as new definition */
                    st_insert(t->attr.name, t->lineno, location++, t->attr.scope, "function", "integer");
                }
                else
                {
                    /* already in table, so ignore location,
                       add line number of use only */
                    st_insert(t->attr.name, t->lineno, location++, t->attr.scope, "function", "void");
                }
            }
            else
                typeError(t, "Error 4: Invalid declaration. Already declared.");
            break;

        case CallK:
            if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1)
            {
                if (!strcmp(t->attr.name, "input") && !strcmp(t->attr.name, "output"))
                    typeError(t, "Erro 5: Invalid call. Not delcared.");
            }
            else
                st_insert(t->attr.name, t->lineno, location++, t->attr.scope, "call", "-");
        case ReturnK:
            break;
        default:
            break;
        }
        break;
    case ExpK:
        switch (t->kind.exp)
        {
        case IdK:
            if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1)
            {
                typeError(t, "Error 1: Not declared");
            }
            else
            {
                st_insert(t->attr.name, t->lineno, 0, t->attr.scope, "variable", "integer");
            }
            break;
        case VectorK:
            if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1)
            {
                typeError(t, "Error 1: Not declared");
            }
            else
            {
                st_insert(t->attr.name, t->lineno, 0, t->attr.scope, "array", "integer");
            }
            break;
        case VectorIdK:
            if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1)
            {
                typeError(t, "Error 1: Not declared");
            }
            else
            {
                st_insert(t->attr.name, t->lineno, 0, t->attr.scope, "array index", "integer");
            }
        case TypeK:
            break;
        default:
            break;
        }
        break;
    default:
        break;
    }
}

/* Function buildSymtab constructs the symbol
 * table by preorder traversal of the syntax tree
 */
void buildSymtab(TreeNode *syntaxTree)
{
    traverse(syntaxTree, insertNode, nullProc);
    if (st_lookup("main", "global") == -1)
    {
        printf("main not declared");
        Error = TRUE;
    }
    if (TraceAnalyze)
    {
        fprintf(listing, "\nSymbol table:\n\n");
        printSymTab(listing);
    }
}

/* Procedure checkNode performs
 * type checking at a single tree node
 */
static void checkNode(TreeNode *t)
{
    switch (t->nodekind)
    {
    case ExpK:
        switch (t->kind.exp)
        {
        case OpK:
            break;
        default:
            break;
        }
        break;
    case StmtK:
        switch (t->kind.stmt)
        {
        case IfK:
            if (t->child[0]->type == IntegerK && t->child[1]->type == IntegerK)
                typeError(t->child[0], "if test is not Boolean");
            break;
        case AssignK:
            if (t->child[0]->type != IntegerK || t->child[1]->type != IntegerK)
                typeError(t->child[0], "assignment of non-integer value");
            else if (t->child[1]->kind.stmt == CallK)
            {
                if (strcmp(st_lookup_type(t->child[1]->attr.name, "global"), "void") == 0)
                    typeError(t->child[1], "assignment of void return");
            }
            break;
        default:
            break;
        }
        break;
    default:
        break;
    }
}

/* Procedure typeCheck performs type checking
 * by a postorder syntax tree traversal
 */
void typeCheck(TreeNode *syntaxTree)
{
    traverse(syntaxTree, nullProc, checkNode);
}
