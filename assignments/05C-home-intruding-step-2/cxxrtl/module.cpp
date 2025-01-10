#include "module.h"

#if defined(CXXRTL_INCLUDE_CAPI_IMPL) || \
    defined(CXXRTL_INCLUDE_VCD_CAPI_IMPL)
#include <cxxrtl/capi/cxxrtl_capi.cc>
#endif

#if defined(CXXRTL_INCLUDE_VCD_CAPI_IMPL)
#include <cxxrtl/capi/cxxrtl_capi_vcd.cc>
#endif

using namespace cxxrtl_yosys;

namespace cxxrtl_design {

void p_bench::reset() {
}

bool p_bench::eval(performer *performer) {
	bool converged = true;
	bool posedge_p_clk = this->posedge_p_clk();
	value<1> i_procmux_24_230__CMP;
	value<1> i_procmux_24_229__CMP;
	value<1> i_procmux_24_225__CMP;
	value<1> i_procmux_24_224__CMP;
	// \hdlname: TARGET trigger
	// \src: TARGET.v:13.9-13.16
	value<1> p_TARGET_2e_trigger;
	// \hdlname: TARGET digit
	// \src: TARGET.v:15.15-15.20
	value<4> p_TARGET_2e_digit;
	// \hdlname: UUT clk
	// \src: UUT.v:10.9-10.12
	value<1> p_UUT_2e_clk;
	// \hdlname: UUT reset
	// \src: UUT.v:12.9-12.14
	value<1> p_UUT_2e_reset;
	// \hdlname: UUT step
	// \src: UUT.v:20.13-20.17
	value<4> p_UUT_2e_step;
	// \src: counter.v:31.24-31.34
	value<1> i_flatten_5c_UUT_2e__5c_counter__0_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y;
	// \hdlname: UUT counter_0 enable
	// \src: counter.v:12.9-12.15
	value<1> p_UUT_2e_counter__0_2e_enable;
	// \src: counter.v:31.24-31.34
	value<1> i_flatten_5c_UUT_2e__5c_counter__1_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y;
	// \hdlname: UUT counter_1 enable
	// \src: counter.v:12.9-12.15
	value<1> p_UUT_2e_counter__1_2e_enable;
	// connection
	p_UUT_2e_step = p_UUT_2e_counter__active_2e_count.curr;
	// \src: counter.v:31.24-31.34
	// cell $flatten\UUT.\counter_0.$eq$counter.v:31$33
	i_flatten_5c_UUT_2e__5c_counter__0_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y = eq_uu<1>(p_UUT_2e_counter__0_2e_count.curr, value<4>{0x9u});
	// \src: UUT.v:24.13-24.22
	// cell $flatten\UUT.$eq$UUT.v:24$1
	p_UUT_2e_counter__0_2e_enable = eq_uu<1>(p_UUT_2e_step, value<4>{0x3u});
	// \src: counter.v:31.24-31.34
	// cell $flatten\UUT.\counter_1.$eq$counter.v:31$33
	i_flatten_5c_UUT_2e__5c_counter__1_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y = eq_uu<1>(p_UUT_2e_counter__1_2e_count.curr, value<4>{0x9u});
	// cells $procmux$232 $flatten\UUT.$eq$UUT.v:60$7 $procmux$235 $flatten\UUT.$eq$UUT.v:58$6
	p_TARGET_2e_digit = (eq_uu<1>(p_UUT_2e_step, value<4>{0x3u}) ? p_UUT_2e_counter__2_2e_count.curr : (eq_uu<1>(p_UUT_2e_step, value<4>{0x2u}) ? p_UUT_2e_counter__1_2e_count.curr : p_UUT_2e_counter__0_2e_count.curr));
	// \src: counter.v:32.20-32.42
	// cell $flatten\UUT.\counter_0.$logic_and$counter.v:32$34
	p_UUT_2e_counter__1_2e_enable = logic_and<1>(p_UUT_2e_counter__0_2e_enable, i_flatten_5c_UUT_2e__5c_counter__0_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y);
	// \full_case: 1
	// \src: TARGET.v:72.3-134.10
	// cell $procmux$224_CMP0
	i_procmux_24_224__CMP = eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x8u});
	// connection
	p_UUT_2e_reset = p_reset;
	// \full_case: 1
	// \src: TARGET.v:72.3-134.10
	// cell $procmux$229_CMP0
	i_procmux_24_229__CMP = eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x4u});
	// \full_case: 1
	// \src: TARGET.v:72.3-134.10
	// cell $procmux$225_CMP0
	i_procmux_24_225__CMP = logic_not<1>(p_TARGET_2e_state.curr);
	// \full_case: 1
	// \src: TARGET.v:72.3-134.10
	// cell $procmux$230_CMP0
	i_procmux_24_230__CMP = logic_not<1>(p_TARGET_2e_state.curr);
	// connection
	p_UUT_2e_clk = p_clk;
	// cells $auto$proc_dlatch.cc:433:proc_dlatch$269 $procmux$223 $auto$proc_dlatch.cc:263:make_hold$281 $auto$proc_dlatch.cc:250:make_hold$273 $auto$proc_dlatch.cc:250:make_hold$271
	if (and_uu<1>(not_u<1>(i_procmux_24_225__CMP), not_u<1>(i_procmux_24_224__CMP)) == value<1> {0u}) {
		p_TARGET_2e_alarm.next = (i_procmux_24_224__CMP ? value<1>{0x1u} : (i_procmux_24_225__CMP ? value<1>{0u} : value<1>{0u}));
	}
	// cells $procdff$306 $procmux$259 $procmux$256 $flatten\UUT.\counter_1.$logic_and$counter.v:32$34 $procmux$254 $flatten\UUT.\counter_2.$eq$counter.v:31$33 $flatten\UUT.\counter_2.$add$counter.v:25$32
	if (posedge_p_clk) {
		p_UUT_2e_counter__2_2e_count.next = (p_UUT_2e_reset ? value<4>{0u} : (logic_and<1>(p_UUT_2e_counter__1_2e_enable, i_flatten_5c_UUT_2e__5c_counter__1_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y) ? (eq_uu<1>(p_UUT_2e_counter__2_2e_count.curr, value<4>{0x9u}) ? value<4>{0u} : add_uu<32>(p_UUT_2e_counter__2_2e_count.curr, value<32>{0x1u}).slice<3,0>().val()) : p_UUT_2e_counter__2_2e_count.curr));
	}
	// cells $procdff$307 $procmux$267 $flatten\UUT.$logic_or$UUT.v:51$4 $flatten\UUT.$eq$UUT.v:51$3 $procmux$262 $flatten\UUT.\counter_active.$eq$counter.v:31$33 $flatten\UUT.\counter_active.$add$counter.v:25$32
	if (posedge_p_clk) {
		p_UUT_2e_counter__active_2e_count.next = (logic_or<1>(eq_uu<1>(p_UUT_2e_step, value<4>{0x3u}), p_UUT_2e_reset) ? value<4>{0u} : (eq_uu<1>(p_UUT_2e_counter__active_2e_count.curr, value<4>{0x9u}) ? value<4>{0u} : add_uu<32>(p_UUT_2e_counter__active_2e_count.curr, value<32>{0x1u}).slice<3,0>().val()));
	}
	// cells $procdff$303 $procmux$42 $procmux$208 $procmux$209_CMP0 $procmux$210_CMP0 $procmux$211_CMP0 $procmux$212_CMP0 $procmux$213_CMP0 $procmux$214_CMP0 $procmux$215_CMP0 $procmux$216_CMP0 $procmux$217_CMP0 $procmux$218_CMP0 $procmux$219_CMP0 $procmux$220_CMP0 $procmux$221_CMP0 $procmux$48 $procmux$49_CMP0 $procmux$55 $procmux$56_CMP0 $procmux$53 $procmux$62 $procmux$63_CMP0 $procmux$70 $procmux$71_CMP0 $procmux$79 $procmux$80_CMP0 $procmux$89 $procmux$90_CMP0 $flatten\TARGET.$ternary$TARGET.v:112$22 $flatten\TARGET.$eq$TARGET.v:112$21 $procmux$100 $procmux$101_CMP0 $flatten\TARGET.$ternary$TARGET.v:108$20 $flatten\TARGET.$eq$TARGET.v:108$19 $procmux$112 $procmux$113_CMP0 $flatten\TARGET.$ternary$TARGET.v:104$18 $flatten\TARGET.$eq$TARGET.v:104$17 $procmux$125 $procmux$126_CMP0 $procmux$139 $procmux$140_CMP0 $procmux$154 $procmux$155_CMP0 $procmux$170 $procmux$171_CMP0 $flatten\TARGET.$ternary$TARGET.v:84$15 $flatten\TARGET.$eq$TARGET.v:84$14 $procmux$187 $procmux$188_CMP0 $flatten\TARGET.$ternary$TARGET.v:80$13 $flatten\TARGET.$eq$TARGET.v:80$12 $procmux$205 $procmux$206_CMP0 $flatten\TARGET.$ternary$TARGET.v:76$11 $flatten\TARGET.$eq$TARGET.v:76$10
	if (posedge_p_clk) {
		p_TARGET_2e_state.next = (p_reset ? value<4>{0x4u} : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x8u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x8u}) ? value<4>{0x5u} : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x4u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x4u}) ? (p_TARGET_2e_trigger ? value<4>{0x8u} : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x4u}) ? value<4>{0x5u} : value<4>{0u})) : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xau}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xau}) ? value<4>{0u} : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x9u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x9u}) ? value<4>{0xau} : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x3u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x3u}) ? (eq_uu<1>(p_TARGET_2e_digit, value<4>{0x2u}) ? value<32>{0x4u} : value<32>{0u}).slice<3,0>().val() : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x2u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x2u}) ? (eq_uu<1>(p_TARGET_2e_digit, value<4>{0x2u}) ? value<32>{0x3u} : value<32>{0xau}).slice<3,0>().val() : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x1u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x1u}) ? (eq_uu<1>(p_TARGET_2e_digit, value<4>{0x2u}) ? value<32>{0x2u} : value<32>{0x9u}).slice<3,0>().val() : value<4>{0u}) : (logic_not<1>(p_TARGET_2e_state.curr) ? (logic_not<1>(p_TARGET_2e_state.curr) ? p_TARGET_2e_state.curr : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xcu}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xcu}) ? value<4>{0x4u} : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xbu}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xbu}) ? value<4>{0xcu} : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x7u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x7u}) ? (eq_uu<1>(p_TARGET_2e_digit, value<4>{0x2u}) ? value<32>{0u} : value<32>{0x4u}).slice<3,0>().val() : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x6u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x6u}) ? (eq_uu<1>(p_TARGET_2e_digit, value<4>{0x2u}) ? value<32>{0x7u} : value<32>{0xcu}).slice<3,0>().val() : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x5u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x5u}) ? (eq_uu<1>(p_TARGET_2e_digit, value<4>{0x2u}) ? value<32>{0x6u} : value<32>{0xbu}).slice<3,0>().val() : value<4>{0u}) : p_TARGET_2e_state.curr))))))))))))));
	}
	// cells $procdff$304 $procmux$243 $procmux$240 $procmux$238 $flatten\UUT.\counter_0.$add$counter.v:25$32
	if (posedge_p_clk) {
		p_UUT_2e_counter__0_2e_count.next = (p_UUT_2e_reset ? value<4>{0u} : (p_UUT_2e_counter__0_2e_enable ? (i_flatten_5c_UUT_2e__5c_counter__0_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y ? value<4>{0u} : add_uu<32>(p_UUT_2e_counter__0_2e_count.curr, value<32>{0x1u}).slice<3,0>().val()) : p_UUT_2e_counter__0_2e_count.curr));
	}
	// cells $procdff$305 $procmux$251 $procmux$248 $procmux$246 $flatten\UUT.\counter_1.$add$counter.v:25$32
	if (posedge_p_clk) {
		p_UUT_2e_counter__1_2e_count.next = (p_UUT_2e_reset ? value<4>{0u} : (p_UUT_2e_counter__1_2e_enable ? (i_flatten_5c_UUT_2e__5c_counter__1_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y ? value<4>{0u} : add_uu<32>(p_UUT_2e_counter__1_2e_count.curr, value<32>{0x1u}).slice<3,0>().val()) : p_UUT_2e_counter__1_2e_count.curr));
	}
	// cells $auto$proc_dlatch.cc:433:proc_dlatch$286 $procmux$228 $auto$proc_dlatch.cc:263:make_hold$298 $auto$proc_dlatch.cc:250:make_hold$290 $auto$proc_dlatch.cc:250:make_hold$288
	if (and_uu<1>(not_u<1>(i_procmux_24_230__CMP), not_u<1>(i_procmux_24_229__CMP)) == value<1> {0u}) {
		p_TARGET_2e_armed.next = (i_procmux_24_229__CMP ? value<1>{0x1u} : (i_procmux_24_230__CMP ? value<1>{0u} : value<1>{0u}));
	}
	// connection
	p_armed = p_TARGET_2e_armed.curr;
	// connection
	p_alarm = p_TARGET_2e_alarm.curr;
	return converged;
}

void p_bench::debug_eval() {
	// \src: counter.v:31.24-31.34
	value<1> i_flatten_5c_UUT_2e__5c_counter__active_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y;
	// \src: UUT.v:24.13-24.22
	// cell $flatten\UUT.$eq$UUT.v:24$1
	p_UUT_2e_counter__0_2e_enable = eq_uu<1>(p_UUT_2e_counter__active_2e_count.curr, value<4>{0x3u});
	// connection
	p_UUT_2e_counter__0_2e_count__finish = eq_uu<1>(p_UUT_2e_counter__0_2e_count.curr, value<4>{0x9u});
	// cells $procmux$232 $flatten\UUT.$eq$UUT.v:60$7 $procmux$235 $flatten\UUT.$eq$UUT.v:58$6
	p_UUT_2e_digit = (eq_uu<1>(p_UUT_2e_counter__active_2e_count.curr, value<4>{0x3u}) ? p_UUT_2e_counter__2_2e_count.curr : (eq_uu<1>(p_UUT_2e_counter__active_2e_count.curr, value<4>{0x2u}) ? p_UUT_2e_counter__1_2e_count.curr : p_UUT_2e_counter__0_2e_count.curr));
	// \src: counter.v:32.20-32.42
	// cell $flatten\UUT.\counter_0.$logic_and$counter.v:32$34
	p_UUT_2e_counter__0_2e_rollover = logic_and<1>(p_UUT_2e_counter__0_2e_enable, p_UUT_2e_counter__0_2e_count__finish);
	// connection
	p_UUT_2e_counter__1_2e_count__finish = eq_uu<1>(p_UUT_2e_counter__1_2e_count.curr, value<4>{0x9u});
	// \src: counter.v:32.20-32.42
	// cell $flatten\UUT.\counter_1.$logic_and$counter.v:32$34
	p_UUT_2e_counter__1_2e_rollover = logic_and<1>(p_UUT_2e_counter__0_2e_rollover, p_UUT_2e_counter__1_2e_count__finish);
	// \src: counter.v:31.24-31.34
	// cell $flatten\UUT.\counter_active.$eq$counter.v:31$33
	i_flatten_5c_UUT_2e__5c_counter__active_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y = eq_uu<1>(p_UUT_2e_counter__active_2e_count.curr, value<4>{0x9u});
	// cells $flatten\UUT.$logic_or$UUT.v:51$4 $flatten\UUT.$eq$UUT.v:51$3
	p_UUT_2e_counter__active_2e_reset = logic_or<1>(eq_uu<1>(p_UUT_2e_counter__active_2e_count.curr, value<4>{0x3u}), p_reset);
	// cells $procmux$208 $procmux$209_CMP0 $procmux$210_CMP0 $procmux$211_CMP0 $procmux$212_CMP0 $procmux$213_CMP0 $procmux$214_CMP0 $procmux$215_CMP0 $procmux$216_CMP0 $procmux$217_CMP0 $procmux$218_CMP0 $procmux$219_CMP0 $procmux$220_CMP0 $procmux$221_CMP0 $procmux$48 $procmux$49_CMP0 $procmux$55 $procmux$56_CMP0 $procmux$53 $procmux$62 $procmux$63_CMP0 $procmux$70 $procmux$71_CMP0 $procmux$79 $procmux$80_CMP0 $procmux$89 $procmux$90_CMP0 $flatten\TARGET.$ternary$TARGET.v:112$22 $flatten\TARGET.$eq$TARGET.v:112$21 $procmux$100 $procmux$101_CMP0 $flatten\TARGET.$ternary$TARGET.v:108$20 $flatten\TARGET.$eq$TARGET.v:108$19 $procmux$112 $procmux$113_CMP0 $flatten\TARGET.$ternary$TARGET.v:104$18 $flatten\TARGET.$eq$TARGET.v:104$17 $procmux$125 $procmux$126_CMP0 $procmux$139 $procmux$140_CMP0 $procmux$154 $procmux$155_CMP0 $procmux$170 $procmux$171_CMP0 $flatten\TARGET.$ternary$TARGET.v:84$15 $flatten\TARGET.$eq$TARGET.v:84$14 $procmux$187 $procmux$188_CMP0 $flatten\TARGET.$ternary$TARGET.v:80$13 $flatten\TARGET.$eq$TARGET.v:80$12 $procmux$205 $procmux$206_CMP0 $flatten\TARGET.$ternary$TARGET.v:76$11 $flatten\TARGET.$eq$TARGET.v:76$10
	p_TARGET_2e_state__next = (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x8u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x8u}) ? value<4>{0x5u} : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x4u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x4u}) ? (p_TARGET_2e_trigger ? value<4>{0x8u} : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x4u}) ? value<4>{0x5u} : value<4>{0u})) : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xau}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xau}) ? value<4>{0u} : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x9u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x9u}) ? value<4>{0xau} : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x3u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x3u}) ? (eq_uu<1>(p_UUT_2e_digit, value<4>{0x2u}) ? value<32>{0x4u} : value<32>{0u}).slice<3,0>().val() : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x2u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x2u}) ? (eq_uu<1>(p_UUT_2e_digit, value<4>{0x2u}) ? value<32>{0x3u} : value<32>{0xau}).slice<3,0>().val() : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x1u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x1u}) ? (eq_uu<1>(p_UUT_2e_digit, value<4>{0x2u}) ? value<32>{0x2u} : value<32>{0x9u}).slice<3,0>().val() : value<4>{0u}) : (logic_not<1>(p_TARGET_2e_state.curr) ? (logic_not<1>(p_TARGET_2e_state.curr) ? p_TARGET_2e_state.curr : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xcu}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xcu}) ? value<4>{0x4u} : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xbu}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0xbu}) ? value<4>{0xcu} : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x7u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x7u}) ? (eq_uu<1>(p_UUT_2e_digit, value<4>{0x2u}) ? value<32>{0u} : value<32>{0x4u}).slice<3,0>().val() : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x6u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x6u}) ? (eq_uu<1>(p_UUT_2e_digit, value<4>{0x2u}) ? value<32>{0x7u} : value<32>{0xcu}).slice<3,0>().val() : value<4>{0u}) : (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x5u}) ? (eq_uu<1>(p_TARGET_2e_state.curr, value<4>{0x5u}) ? (eq_uu<1>(p_UUT_2e_digit, value<4>{0x2u}) ? value<32>{0x6u} : value<32>{0xbu}).slice<3,0>().val() : value<4>{0u}) : p_TARGET_2e_state.curr)))))))))))));
	// \src: counter.v:31.24-31.34
	// cell $flatten\UUT.\counter_active.$eq$counter.v:31$33
	p_UUT_2e_counter__active_2e_count__finish = i_flatten_5c_UUT_2e__5c_counter__active_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y;
	// \src: counter.v:31.24-31.34
	// cell $flatten\UUT.\counter_2.$eq$counter.v:31$33
	p_UUT_2e_counter__2_2e_count__finish = eq_uu<1>(p_UUT_2e_counter__2_2e_count.curr, value<4>{0x9u});
	// connection
	p_UUT_2e_counter__active_2e_enable = value<1>{0x1u};
	// connection
	p_UUT_2e_counter__active_2e_rollover = i_flatten_5c_UUT_2e__5c_counter__active_2e__24_eq_24_counter_2e_v_3a_31_24_33__Y;
	// connection
	p_UUT_2e_counter__2_2e_rollover = logic_and<1>(p_UUT_2e_counter__1_2e_rollover, p_UUT_2e_counter__2_2e_count__finish);
}

CXXRTL_EXTREMELY_COLD
void p_bench::debug_info(debug_items *items, debug_scopes *scopes, std::string path, metadata_map &&cell_attrs) {
	assert(path.empty() || path[path.size() - 1] == ' ');
	if (scopes) {
		scopes->add(path.empty() ? path : path.substr(0, path.size() - 1), "bench", metadata_map({
			{ "top", UINT64_C(1) },
			{ "src", "bench.v:1.1-37.10" },
		}), std::move(cell_attrs));
		scopes->add(path, "TARGET", "TARGET", "hdlname\000sTARGET\000src\000sTARGET.v:9.1-192.10\000", "src\000sbench.v:23.10-34.4\000");
		scopes->add(path, "UUT", "UUT", "hdlname\000sUUT\000src\000sUUT.v:9.1-67.10\000", "src\000sbench.v:14.7-21.4\000");
		scopes->add(path, "UUT counter_0", "counter", "hdlname\000scounter\000src\000scounter.v:9.1-33.10\000", "src\000sUUT.v:22.11-29.4\000");
		scopes->add(path, "UUT counter_1", "counter", "hdlname\000scounter\000src\000scounter.v:9.1-33.10\000", "src\000sUUT.v:31.10-38.4\000");
		scopes->add(path, "UUT counter_2", "counter", "hdlname\000scounter\000src\000scounter.v:9.1-33.10\000", "src\000sUUT.v:40.10-46.4\000");
		scopes->add(path, "UUT counter_active", "counter", "hdlname\000scounter\000src\000scounter.v:9.1-33.10\000", "src\000sUUT.v:48.10-54.4\000");
	}
	if (items) {
		items->add(path, "TARGET clk", "src\000sbench.v:2.9-2.12\000", debug_alias(), p_clk);
		items->add(path, "TARGET reset", "src\000sbench.v:4.9-4.14\000", debug_alias(), p_reset);
		items->add(path, "TARGET trigger", "src\000sTARGET.v:13.9-13.16\000", debug_eval_outline, p_TARGET_2e_trigger);
		static const value<2> const_p_TARGET_2e_command = value<2>{0x2u};
		items->add(path, "TARGET command", "src\000sTARGET.v:14.15-14.22\000", const_p_TARGET_2e_command);
		items->add(path, "TARGET digit", "src\000sUUT.v:15.20-15.25\000", debug_eval_outline, p_UUT_2e_digit);
		static const value<1> const_p_TARGET_2e_digit__enterd = value<1>{0x1u};
		items->add(path, "TARGET digit_enterd", "src\000sTARGET.v:16.9-16.21\000", const_p_TARGET_2e_digit__enterd);
		items->add(path, "TARGET state_ref", "src\000sTARGET.v:50.12-50.17\000", debug_alias(), p_TARGET_2e_state);
		items->add(path, "TARGET armed", "src\000sTARGET.v:21.14-21.19\000", p_TARGET_2e_armed, 0, debug_item::DRIVEN_SYNC);
		items->add(path, "TARGET alarm", "src\000sTARGET.v:22.14-22.19\000", p_TARGET_2e_alarm, 0, debug_item::DRIVEN_SYNC);
		items->add(path, "TARGET state", "src\000sTARGET.v:50.12-50.17\000", p_TARGET_2e_state, 0, debug_item::DRIVEN_SYNC);
		items->add(path, "TARGET state_next", "src\000sTARGET.v:51.12-51.22\000", debug_eval_outline, p_TARGET_2e_state__next);
		items->add(path, "TARGET active_digit", "src\000sTARGET.v:52.6-52.18\000", debug_eval_outline, p_TARGET_2e_active__digit);
		items->add(path, "UUT clk", "src\000sbench.v:2.9-2.12\000", debug_alias(), p_clk);
		items->add(path, "UUT enable", "src\000sbench.v:3.9-3.15\000", debug_alias(), p_enable);
		items->add(path, "UUT reset", "src\000sbench.v:4.9-4.14\000", debug_alias(), p_reset);
		static const value<2> const_p_UUT_2e_command = value<2>{0x2u};
		items->add(path, "UUT command", "src\000sUUT.v:14.16-14.23\000", const_p_UUT_2e_command);
		items->add(path, "UUT digit", "src\000sUUT.v:15.20-15.25\000", debug_eval_outline, p_UUT_2e_digit);
		static const value<1> const_p_UUT_2e_digit__entered = value<1>{0x1u};
		items->add(path, "UUT digit_entered", "src\000sUUT.v:16.10-16.23\000", const_p_UUT_2e_digit__entered);
		items->add(path, "UUT en_digit_1", "src\000scounter.v:15.10-15.18\000", debug_eval_outline, p_UUT_2e_counter__0_2e_rollover);
		items->add(path, "UUT en_digit_2", "src\000scounter.v:15.10-15.18\000", debug_eval_outline, p_UUT_2e_counter__1_2e_rollover);
		items->add(path, "UUT digit_0", "src\000scounter.v:14.20-14.25\000", debug_alias(), p_UUT_2e_counter__0_2e_count);
		items->add(path, "UUT digit_1", "src\000scounter.v:14.20-14.25\000", debug_alias(), p_UUT_2e_counter__1_2e_count);
		items->add(path, "UUT digit_2", "src\000scounter.v:14.20-14.25\000", debug_alias(), p_UUT_2e_counter__2_2e_count);
		items->add(path, "UUT step", "src\000scounter.v:14.20-14.25\000", debug_alias(), p_UUT_2e_counter__active_2e_count);
		items->add(path, "UUT counter_0 count_finish", "src\000scounter.v:18.7-18.19\000", debug_eval_outline, p_UUT_2e_counter__0_2e_count__finish);
		items->add(path, "UUT counter_0 rollover", "src\000scounter.v:15.10-15.18\000", debug_eval_outline, p_UUT_2e_counter__0_2e_rollover);
		items->add(path, "UUT counter_0 count", "src\000scounter.v:14.20-14.25\000", p_UUT_2e_counter__0_2e_count, 0, debug_item::DRIVEN_SYNC);
		items->add(path, "UUT counter_0 enable", "src\000scounter.v:12.9-12.15\000", debug_eval_outline, p_UUT_2e_counter__0_2e_enable);
		items->add(path, "UUT counter_0 reset", "src\000sbench.v:4.9-4.14\000", debug_alias(), p_reset);
		items->add(path, "UUT counter_0 clk", "src\000sbench.v:2.9-2.12\000", debug_alias(), p_clk);
		items->add(path, "UUT counter_1 count_finish", "src\000scounter.v:18.7-18.19\000", debug_eval_outline, p_UUT_2e_counter__1_2e_count__finish);
		items->add(path, "UUT counter_1 rollover", "src\000scounter.v:15.10-15.18\000", debug_eval_outline, p_UUT_2e_counter__1_2e_rollover);
		items->add(path, "UUT counter_1 count", "src\000scounter.v:14.20-14.25\000", p_UUT_2e_counter__1_2e_count, 0, debug_item::DRIVEN_SYNC);
		items->add(path, "UUT counter_1 enable", "src\000scounter.v:15.10-15.18\000", debug_eval_outline, p_UUT_2e_counter__0_2e_rollover);
		items->add(path, "UUT counter_1 reset", "src\000sbench.v:4.9-4.14\000", debug_alias(), p_reset);
		items->add(path, "UUT counter_1 clk", "src\000sbench.v:2.9-2.12\000", debug_alias(), p_clk);
		items->add(path, "UUT counter_2 count_finish", "src\000scounter.v:18.7-18.19\000", debug_eval_outline, p_UUT_2e_counter__2_2e_count__finish);
		items->add(path, "UUT counter_2 rollover", "src\000scounter.v:15.10-15.18\000", debug_eval_outline, p_UUT_2e_counter__2_2e_rollover);
		items->add(path, "UUT counter_2 count", "src\000scounter.v:14.20-14.25\000", p_UUT_2e_counter__2_2e_count, 0, debug_item::DRIVEN_SYNC);
		items->add(path, "UUT counter_2 enable", "src\000scounter.v:15.10-15.18\000", debug_eval_outline, p_UUT_2e_counter__1_2e_rollover);
		items->add(path, "UUT counter_2 reset", "src\000sbench.v:4.9-4.14\000", debug_alias(), p_reset);
		items->add(path, "UUT counter_2 clk", "src\000sbench.v:2.9-2.12\000", debug_alias(), p_clk);
		items->add(path, "UUT counter_active count_finish", "src\000scounter.v:18.7-18.19\000", debug_eval_outline, p_UUT_2e_counter__active_2e_count__finish);
		items->add(path, "UUT counter_active rollover", "src\000scounter.v:15.10-15.18\000", debug_eval_outline, p_UUT_2e_counter__active_2e_rollover);
		items->add(path, "UUT counter_active count", "src\000scounter.v:14.20-14.25\000", p_UUT_2e_counter__active_2e_count, 0, debug_item::DRIVEN_SYNC);
		items->add(path, "UUT counter_active enable", "src\000scounter.v:12.9-12.15\000", debug_eval_outline, p_UUT_2e_counter__active_2e_enable);
		items->add(path, "UUT counter_active reset", "src\000scounter.v:11.9-11.14\000", debug_eval_outline, p_UUT_2e_counter__active_2e_reset);
		items->add(path, "UUT counter_active clk", "src\000sbench.v:2.9-2.12\000", debug_alias(), p_clk);
		static const value<1> const_p_uut__digit__entered = value<1>{0x1u};
		items->add(path, "uut_digit_entered", "src\000sbench.v:12.8-12.25\000", const_p_uut__digit__entered);
		static const value<2> const_p_uut__command = value<2>{0x2u};
		items->add(path, "uut_command", "src\000sbench.v:11.14-11.25\000", const_p_uut__command);
		items->add(path, "uut_input_digit", "src\000sUUT.v:15.20-15.25\000", debug_eval_outline, p_UUT_2e_digit);
		items->add(path, "state", "src\000sbench.v:8.16-8.21\000", p_state, 0, debug_item::OUTPUT|debug_item::UNDRIVEN);
		items->add(path, "alarm", "src\000sbench.v:7.10-7.15\000", p_alarm, 0, debug_item::OUTPUT|debug_item::DRIVEN_COMB);
		items->add(path, "armed", "src\000sbench.v:6.10-6.15\000", p_armed, 0, debug_item::OUTPUT|debug_item::DRIVEN_COMB);
		items->add(path, "reset", "src\000sbench.v:4.9-4.14\000", p_reset, 0, debug_item::INPUT|debug_item::UNDRIVEN);
		items->add(path, "enable", "src\000sbench.v:3.9-3.15\000", p_enable, 0, debug_item::INPUT|debug_item::UNDRIVEN);
		items->add(path, "clk", "src\000sbench.v:2.9-2.12\000", p_clk, 0, debug_item::INPUT|debug_item::UNDRIVEN);
	}
}

} // namespace cxxrtl_design

extern "C"
cxxrtl_toplevel cxxrtl_design_create() {
	return new _cxxrtl_toplevel { std::unique_ptr<cxxrtl_design::p_bench>(new cxxrtl_design::p_bench) };
}
