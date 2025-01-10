#ifndef CXXRTL_DESIGN_HEADER
#define CXXRTL_DESIGN_HEADER

#include <cxxrtl/capi/cxxrtl_capi.h>

#ifdef __cplusplus
extern "C" {
#endif

cxxrtl_toplevel cxxrtl_design_create();

#ifdef __cplusplus
}
#endif

#ifdef __cplusplus

#include <cxxrtl/cxxrtl.h>

using namespace cxxrtl;

namespace cxxrtl_design {

// \hdlname: bench
// \top: 1
// \src: bench.v:1.1-37.10
struct p_bench : public module {
	// \hdlname: TARGET armed
	// \src: TARGET.v:21.14-21.19
	wire<1> p_TARGET_2e_armed;
	// \hdlname: TARGET alarm
	// \src: TARGET.v:22.14-22.19
	wire<1> p_TARGET_2e_alarm;
	// \hdlname: TARGET state
	// \src: TARGET.v:50.12-50.17
	wire<4> p_TARGET_2e_state;
	// \hdlname: UUT counter_0 count
	// \src: counter.v:14.20-14.25
	wire<4> p_UUT_2e_counter__0_2e_count;
	// \hdlname: UUT counter_1 count
	// \src: counter.v:14.20-14.25
	wire<4> p_UUT_2e_counter__1_2e_count;
	// \hdlname: UUT counter_2 count
	// \src: counter.v:14.20-14.25
	wire<4> p_UUT_2e_counter__2_2e_count;
	// \hdlname: UUT counter_active count
	// \src: counter.v:14.20-14.25
	wire<4> p_UUT_2e_counter__active_2e_count;
	// \src: bench.v:8.16-8.21
	/*output*/ value<4> p_state;
	// \src: bench.v:7.10-7.15
	/*output*/ value<1> p_alarm;
	// \src: bench.v:6.10-6.15
	/*output*/ value<1> p_armed;
	// \src: bench.v:4.9-4.14
	/*input*/ value<1> p_reset;
	// \src: bench.v:3.9-3.15
	/*input*/ value<1> p_enable;
	// \src: bench.v:2.9-2.12
	/*input*/ value<1> p_clk;
	value<1> prev_p_clk;
	bool posedge_p_clk() const {
		return !prev_p_clk.slice<0>().val() && p_clk.slice<0>().val();
	}
	// \hdlname: TARGET trigger
	// \src: TARGET.v:13.9-13.16
	/*outline*/ value<1> p_TARGET_2e_trigger;
	// \hdlname: TARGET state_next
	// \src: TARGET.v:51.12-51.22
	/*outline*/ value<4> p_TARGET_2e_state__next;
	// \hdlname: TARGET active_digit
	// \src: TARGET.v:52.6-52.18
	/*outline*/ value<1> p_TARGET_2e_active__digit;
	// \hdlname: UUT digit
	// \src: UUT.v:15.20-15.25
	/*outline*/ value<4> p_UUT_2e_digit;
	// \hdlname: UUT counter_0 count_finish
	// \src: counter.v:18.7-18.19
	/*outline*/ value<1> p_UUT_2e_counter__0_2e_count__finish;
	// \hdlname: UUT counter_0 rollover
	// \src: counter.v:15.10-15.18
	/*outline*/ value<1> p_UUT_2e_counter__0_2e_rollover;
	// \hdlname: UUT counter_0 enable
	// \src: counter.v:12.9-12.15
	/*outline*/ value<1> p_UUT_2e_counter__0_2e_enable;
	// \hdlname: UUT counter_1 count_finish
	// \src: counter.v:18.7-18.19
	/*outline*/ value<1> p_UUT_2e_counter__1_2e_count__finish;
	// \hdlname: UUT counter_1 rollover
	// \src: counter.v:15.10-15.18
	/*outline*/ value<1> p_UUT_2e_counter__1_2e_rollover;
	// \hdlname: UUT counter_2 count_finish
	// \src: counter.v:18.7-18.19
	/*outline*/ value<1> p_UUT_2e_counter__2_2e_count__finish;
	// \hdlname: UUT counter_2 rollover
	// \src: counter.v:15.10-15.18
	/*outline*/ value<1> p_UUT_2e_counter__2_2e_rollover;
	// \hdlname: UUT counter_active count_finish
	// \src: counter.v:18.7-18.19
	/*outline*/ value<1> p_UUT_2e_counter__active_2e_count__finish;
	// \hdlname: UUT counter_active rollover
	// \src: counter.v:15.10-15.18
	/*outline*/ value<1> p_UUT_2e_counter__active_2e_rollover;
	// \hdlname: UUT counter_active enable
	// \src: counter.v:12.9-12.15
	/*outline*/ value<1> p_UUT_2e_counter__active_2e_enable;
	// \hdlname: UUT counter_active reset
	// \src: counter.v:11.9-11.14
	/*outline*/ value<1> p_UUT_2e_counter__active_2e_reset;
	p_bench(interior) {}
	p_bench() {
		reset();
	};

	void reset() override;

	bool eval(performer *performer = nullptr) override;

	template<class ObserverT>
	bool commit(ObserverT &observer) {
		bool changed = false;
		if (p_TARGET_2e_armed.commit(observer)) changed = true;
		if (p_TARGET_2e_alarm.commit(observer)) changed = true;
		if (p_TARGET_2e_state.commit(observer)) changed = true;
		if (p_UUT_2e_counter__0_2e_count.commit(observer)) changed = true;
		if (p_UUT_2e_counter__1_2e_count.commit(observer)) changed = true;
		if (p_UUT_2e_counter__2_2e_count.commit(observer)) changed = true;
		if (p_UUT_2e_counter__active_2e_count.commit(observer)) changed = true;
		prev_p_clk = p_clk;
		return changed;
	}

	bool commit() override {
		observer observer;
		return commit<>(observer);
	}

	void debug_eval();
	debug_outline debug_eval_outline { std::bind(&p_bench::debug_eval, this) };

	void debug_info(debug_items *items, debug_scopes *scopes, std::string path, metadata_map &&cell_attrs = {}) override;
}; // struct p_bench

} // namespace cxxrtl_design

#endif // __cplusplus

#endif
