#include "cxxrtl/module.h"
#include "cxxrtl/capi/cxxrtl_capi_vcd.h"
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

const char top_module_name[] = "REF";

int get_rand_pincode()
{
  struct timeval date;
  gettimeofday(&date, NULL);
  srandom(date.tv_sec + (date.tv_usec / 1000000));
  return random() % 1000;
}

int main()
{
  cxxrtl_handle top = cxxrtl_create(cxxrtl_design_create());
  struct cxxrtl_object *clk = cxxrtl_get(top, "clk");
  struct cxxrtl_object *reset = cxxrtl_get(top, "reset");
  struct cxxrtl_object *en = cxxrtl_get(top, "enable");
  struct cxxrtl_object *armed = cxxrtl_get(top, "armed");


  //UUT inside
  struct cxxrtl_object *digit_0 = cxxrtl_get(top, "UUT digit_0");
  struct cxxrtl_object *digit_1 = cxxrtl_get(top, "UUT digit_1");
  struct cxxrtl_object *digit_2 = cxxrtl_get(top, "UUT digit_2");

  //Init VCD Trace
  cxxrtl_vcd vcd = cxxrtl_vcd_create();
  cxxrtl_vcd_timescale(vcd, 1, "ns");
  cxxrtl_vcd_add_from_without_memories(vcd, top);
  FILE *fvcd = fopen("trace.vcd", "w");
  //fprintf(fvcd, "$scope module %s $end", top_module_name);
  size_t vcd_steps = 0;

  //Initial reset and enable
  int is_ready =0;
  int will_ready =0;

  int rand_pincode = get_rand_pincode();
  int module_pincode;
  //Continous clk and simulation
  while(*armed->curr != 0 || !is_ready)
  {
    is_ready=will_ready;

    if(!is_ready)
    {
      *en->next=1;
      *reset->next=1;
    }

    *clk->next=0;
    cxxrtl_step(top);
    cxxrtl_vcd_sample(vcd, vcd_steps++);
    *clk->next=1;
    cxxrtl_step(top);
    cxxrtl_vcd_sample(vcd, vcd_steps++);
    
    if(!is_ready)
    {
      *reset->next=0;
      will_ready=1;
    }

    //clk high
  }
  module_pincode = *digit_2->curr +*digit_1->curr*10 + *digit_0->curr*100;
  cxxrtl_vcd_sample(vcd, vcd_steps++);
  printf("Found pincode: %d\n", module_pincode);

  const char *vcd_data;
  size_t vcd_size;
  do
  {
    cxxrtl_vcd_read(vcd, &vcd_data, &vcd_size);
    fwrite(vcd_data, 1, vcd_size, fvcd);
  } while (vcd_size > 0);

  cxxrtl_vcd_destroy(vcd);
  cxxrtl_destroy(top);
}