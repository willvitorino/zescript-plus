struct Var
{
  char id[1001];
  double dValue;
  int haveValue;
};

struct Lista
{
  struct Var *var;
  struct Lista *next;
};

struct Var* get(struct Lista *cabeca, char id[])
{
  for(struct Lista *aux = cabeca->next; aux != NULL; aux = aux->next)
  {
    if (strcmp(id, aux->var->id) == 0)
    {
      return aux->var;
    }
  }
  return NULL;
}

struct Var *inputVar(char name[])
{
  struct Var *temp = malloc(sizeof(struct Var));
  strcpy(temp->id, name);
  temp->haveValue = 0;

  return temp;
}

int insert_cliente(struct Lista *cabeca, struct Var *e)
{
  /**
    * Inserção Lista inicio.
   **/

  struct Lista *new = malloc(sizeof(struct Lista));
  new->var = e;

  new->next = cabeca->next;
  cabeca->next = new;
}

int show_all(struct Lista *cabeca)
{
  for(struct Lista *aux = cabeca->next; aux != NULL; aux = aux->next) {
    printf("Var: %s", aux->var->id);
  }
  return 0;
}

int find(struct Lista *cabeca, char id[])
{
  for(struct Lista *aux = cabeca->next; aux != NULL; aux = aux->next)
  {
    if (strcmp(id, aux->var->id) == 0)
    {
      return 1;
    }
  }
  return 0;
}