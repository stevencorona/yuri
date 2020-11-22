#pragma once

struct script_data {
	int type;
	union {
		int num;
		char *str;
	} u;
};

struct script_stack {
	int sp,sp_max;
	struct script_data *stack_data;
};


struct script_state {
	struct script_stack *stack;
	int start,end;
	int pos,state;
	int graphic_id;
	int graphic_color;
	int rid,oid;
	char *script,*new_script;
	int defsp,new_pos,new_defsp;
};

unsigned char * parse_script(unsigned char *,int);
int run_script(unsigned char *,int,int,int);

struct dbt* script_get_label_db();
struct dbt* script_get_userfunc_db();

int script_init();
int script_term();
int script_config_read_sub(char*);

extern char mapreg_txt[];