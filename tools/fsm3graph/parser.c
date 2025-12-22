#include <ctype.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TOKEN_SIZE 128

typedef struct state_t_ {
  char name[TOKEN_SIZE];
} state_t;
// Inputs id is name. If an input has more than one bit, then it all of the bits are under the same name
typedef struct input_t_ {
  size_t size;
  char name[TOKEN_SIZE];
} input_t;

typedef input_t output_t;

typedef struct transition_t_ {
  size_t from;
  size_t to;
  size_t input;
  size_t output;
} transition_t;

// Outputs do not differ any way from the inputs.

typedef struct kiss2_t_ {
  input_t *inputs;
  output_t *outputs;
  state_t *states;
  transition_t *transitions;
} kiss2_t;

char *chop_blank(char *s) {
  while (isspace(*s))
    s++;
  return s;
}

char *chop_blank_end(char *s) {
  while (isspace(*s))
    s++;
  if (*s == 0)
    return s;

  char *end = s + strlen(s) - 1;
  while (end > s && isspace(*end))
    end--;
  end[1] = 0;
  return s;
}

// Gets value of a token between 2 sets of whitespcaes, like '    token     '
// would return 'token'
char *get_token(char *s, char token[TOKEN_SIZE]) {
  memset(token, 0, TOKEN_SIZE);
  s = chop_blank(s);
  for (size_t i = 0; *s != '\0' && !isspace(*s) && i < TOKEN_SIZE - 1; ++i) {
    token[i] = *s++;
  }
  return s;
}

char *chop_char(char *s, char c) {
  while (*s != '\0' && *s++ != c)
    ;
  return s;
}

#define VECTOR_INIT_CAP 8
#define vector_append(vector, item)                                                             \
  do {                                                                                          \
    if ((vector)->cap == 0) {                                                                   \
      (vector)->items = malloc(sizeof(*(vector)->items) * VECTOR_INIT_CAP);                     \
      if ((vector)->items == NULL) {                                                            \
        fprintf(stderr, "[ERROR]: Could not allocate memory\n");                                \
      }                                                                                         \
      (vector)->cap = VECTOR_INIT_CAP;                                                          \
      (vector)->size = 0;                                                                       \
    } else if ((vector)->size == (vector)->cap) {                                               \
      (vector)->items = realloc((vector)->items, sizeof(*(vector)->items) * (vector)->cap * 2); \
      if ((vector)->items == NULL) {                                                            \
        fprintf(stderr, "[ERROR]: Could not allocate memory\n");                                \
      }                                                                                         \
      (vector)->cap *= 2;                                                                       \
    }                                                                                           \
    ((vector)->items)[(vector)->size] = (item);                                                 \
    (vector)->size += 1;                                                                        \
  } while (0)

typedef struct inputs_t_ {
  input_t *items;
  size_t cap;
  size_t size;
} inputs_t;

typedef inputs_t outputs_t;

typedef struct states_t_ {
  state_t *items;
  size_t cap;
  size_t size;
} states_t;

typedef struct transitions_t_ {
  transition_t *items;
  size_t cap;
  size_t size;
} transitions_t;

typedef struct fsm_info_t_ {
  inputs_t *inputs;
  outputs_t *outputs;
  states_t *states;
  size_t reset;
  transitions_t *transitions;
} fsm_info_t;

#define MALLOC(a) malloc(sizeof(*a))

void fsm_add_input(fsm_info_t *fsm, char *name) {
  name += 1;                    // Drop \ (\reset -> reset)
  name = chop_blank_end(name);  // Remove trainling whitespaces
  if (fsm->inputs == NULL) {
    fsm->inputs = MALLOC(fsm->inputs);
  }
  for (size_t i = 0; i < fsm->inputs->size; ++i) {
    if (strcmp(fsm->inputs->items[i].name, name) ==
        0) {  // means we already found this input and we just increase the size of the wire
      fsm->inputs->items[i].size += 1;
      return;
    }
  }
  input_t input = {0};
  strcpy(input.name, name);
  input.size = 1;
  vector_append(fsm->inputs, input);
}

void fsm_add_output(fsm_info_t *fsm, char *name) {
  name += 1;                    // Drop \ (\reset -> reset)
  name = chop_blank_end(name);  // Remove trainling whitespaces
  if (fsm->outputs == NULL) {
    fsm->outputs = MALLOC(fsm->outputs);
  }
  for (size_t i = 0; i < fsm->outputs->size; ++i) {
    if (strcmp(fsm->outputs->items[i].name, name) ==
        0) {  // means we already found this output and we just increase the size of the wire
      fsm->outputs->items[i].size += 1;
      return;
    }
  }
  output_t output = {0};
  strcpy(output.name, name);
  output.size = 1;
  vector_append(fsm->outputs, output);
}

void fsm_add_state(fsm_info_t *fsm) {
  if (fsm->states == NULL) {
    fsm->states = MALLOC(fsm->states);
  }
  state_t state;

  vector_append(fsm->states, state);
}

void fsm_add_transition(fsm_info_t *fsm, transition_t tran) {
  if (fsm->transitions == NULL) {
    fsm->transitions = MALLOC(fsm->transitions);
  }
  vector_append(fsm->transitions, tran);
}

#define INPUT_SIGNALS "Input signals:\n"
#define OUTPUT_SIGNALS "Output signals:\n"
#define STATE_ENCODING "State encoding:\n"
#define TRANSITION_TABLE "Transition Table (state_in, ctrl_in, state_out, ctrl_out):\n"

void parse_fsm_info(fsm_info_t *fsm, FILE *f) {
  char *line = NULL;
  size_t len = 0;
  ssize_t read;
  char token[TOKEN_SIZE] = {0};
  char reset_name[TOKEN_SIZE] = {0};
  char *cursor;

  while (-1 != (read = getline(&line, &len, f))) {
    cursor = chop_blank(line);

    if (strcmp(cursor, INPUT_SIGNALS) == 0) {
      while (-1 != (read = getline(&line, &len, f))) {
        if (strlen(line) == 1) {
          break;  // Means we incountered delim line
        }

        cursor = line;
        do {  // While we have tokens
          cursor = get_token(cursor, token);
          // Found an input name
          if ('\\' == token[0]) {
            fsm_add_input(fsm, token);
            break;
          }
        } while (cursor[0] != '\0');
      }
    }

    if (strcmp(cursor, OUTPUT_SIGNALS) == 0) {
      while (-1 != (read = getline(&line, &len, f))) {
        if (strlen(line) == 1) {
          break;  // Means we incountered delim line
        }

        cursor = line;
        do {  // While we have tokens
          cursor = get_token(cursor, token);
          // Found an output name
          if ('\\' == token[0]) {
            fsm_add_output(fsm, token);
            break;
          }
        } while (cursor[0] != '\0');
      }
    }

    if (strcmp(cursor, STATE_ENCODING) == 0) {
      bool reset_found = false;
      while (-1 != (read = getline(&line, &len, f))) {
        if (strlen(line) == 1) {
          break;  // Means we incountered delim line
        }

        cursor = line;
        state_t *state_temp;
        do {  // While we have tokens
          cursor = get_token(cursor, token);
          // Found a state name
          if (strchr(token, ':')) {  // means we are at the first token, where the state number is shown (2:  ...)
            fsm_add_state(fsm);
            if (reset_found)
              break;
          }
          if (strcmp(token, "<RESET") == 0) {
            fsm->reset = fsm->states->size - 1;
            reset_found = true;
            break;
          }
        } while (cursor[0] != '\0');
      }
    }

    if (strcmp(cursor, TRANSITION_TABLE) == 0) {
      while (-1 != (read = getline(&line, &len, f))) {
        if (strlen(line) == 1) {
          break;  // Means we incountered delim line
        }

        cursor = line;
        bool output_side = false;
        transition_t tran = {0};
        do {  // While we have tokens
          cursor = get_token(cursor, token);

          if (strchr(token, ':')) {  // Do not care about index
            continue;
          } else if (strchr(token, '>')) {  // -> means we will be on the output side
            output_side = true;
            continue;
          } else if (strlen(token) != 0 && strchr(token, '\'') == 0 && !output_side) {
            tran.from = atol(token);
          } else if (strlen(token) != 0 && strchr(token, '\'') == 0 && output_side) {
            tran.to = atol(token);
          } else if (strchr(token, '\'') && !output_side) {
            char *t = chop_char(token, '\'');
            // We can get -, which means donot care. I will sub them with 0
            char *tt = t;
            while (*t) {
              if (*t == '-')
                *t = '0';
              t++;
            }
            tran.input = strtoll(tt, NULL, 2);
          } else if (strchr(token, '\'') && output_side) {
            char *t = chop_char(token, '\'');
            tran.output = strtoll(t, NULL, 2);
          } else {
            /* printf("[LOG]: Reached with token '%s'\n", token); */
          }

        } while (cursor[0] != '\0');

        /* printf("%zu %zu\t->\t%zu %zu\n", tran.from, tran.input, tran.to, tran.output); */
        fsm_add_transition(fsm, tran);
      }
    }
  }
  if (line) {
    free(line);
  }
}

void print_transitions(transitions_t t) {
  for (size_t i = 0; i < t.size; ++i) {
    transition_t tt = t.items[i];
    printf("%zu:\t%ld %03lb\t->\t%ld %02lb\n", i, tt.from, tt.input, tt.to, tt.output);
  }
}

/*
# comment
.i 3
.o 2
.p 46
.s 9
.r s0
101 s0 s0 00
...
*/

void parse_kiss2(kiss2_t *kiss2, FILE *f) {
  char *line = NULL;
  size_t len = 0;
  ssize_t read;
  char token[TOKEN_SIZE] = {0};
  char reset_name[TOKEN_SIZE] = {0};
  size_t trans_num = 0;
  while (-1 != (read = getline(&line, &len, f))) {
    // skip whitespcaes and comments
    for (;;) {
      line = get_token(line, token);

      // Encountered comment, skip the line
      if ('#' == token[0]) {
        break;
      }

      // Encountered comment metadata, read the type of data (token[1])
      // and get the next token to get the value
      if ('.' == token[0]) {
        char t = token[1];
        line = get_token(line, token);
        int n = atoi(token);
        switch (t) {
          case 'i':
            kiss2->inputs = malloc(sizeof(*kiss2->inputs) * n);
            break;
          case 'o':
            kiss2->outputs = malloc(sizeof(*kiss2->outputs) * n);
            break;
          case 'p':
            kiss2->transitions = malloc(sizeof(*kiss2->transitions) * n);
            break;
          case 's':
            kiss2->states = malloc(sizeof(*kiss2->states) * n);
            break;
          case 'r':
            strcpy(reset_name, token);
            break;
        };
      }
      // Means we are parsing the transitions
      if ('-' == token[0] || isdigit(token[0])) {
        transition_t *t = &kiss2->transitions[trans_num];
        for (size_t i = 0; token[i] != '\0'; ++i) {
          if ('-' == token[i]) {  // Means do not care, so can substitute with 0;
            token[i] = '0';
          }
        }
      }
    }
  }
}

int main(int argc, char **argv) {
  fsm_info_t fsm = {0};
  FILE *f = fopen(argv[1], "rb");
  if (f == NULL) {
    fprintf(stderr, "[ERROR]: Could not open file %s\n", argv[1]);
    return 1;
  }
  parse_fsm_info(&fsm, f);
  printf("[LOG]: Fsm parsed\n");
  print_transitions(*fsm.transitions);
  fclose(f);
  return 0;
}
