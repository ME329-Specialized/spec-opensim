I changed the setup file to only run to 0.75 seconds since that is consistent with the new SFK runs from ~2 am this morning

Something to look at in the CMC setup is that the initial time value is still 0.3 seconds. I did go ahead and change it to 0 seconds, but here are the original lines if you want to change it back.
lines 14, 15
14		<!--Initial time for the simulation.-->
15		<initial_time>0.029999999999999999</initial_time>

There was a typo in cmc_leg_Actuators
hip_adduction_actuator was actually attached hip_rotation_coordinate (doubling up on hip rotation motors)
This is now corrected in cmc_leg_Actuators

ankle_angle_actuator is attached to knee_angle_coordinate. But we already talked about this one, so I think I will leave as is for you to play around with?


The SFK legs at r = 0.8396 m stil have much nosier and much larger external force data. Since CMC is sensitive to the absolute force values at the midfoot, 
try out the r = 0.8196 m trials first for θ = 102°, 105°, 108°


I also tried out a few CMC runs before leaving it to you in the morning
Model: CMC_leg_t_102_r_0.8196 (θ = 102°, r = 0.8196 m)

Trial 0: run as is with corrected hip_adduction_actuator
	result: optimizaiton fails at t = 0.25 seconds

Trial 1: tune crank_angle_actuator
	old: optimal_max_force = 175
	new: optimal_max_force = 100
	result: optimization fails at t = 0 seconds

Trial 2: tune crank_angle_actuator
	old: optimal_max_force = 100
	new: optimal_max_force = 250
	result: optimization fails at t = 0.41 seconds
	notes: motion actually looked fine up to the time of failure. model failed at about the bottom of the motion
	messages: "Model cannot generate the forces necessary to achieve the target acceleration"

Trial 3: tune crank_angle_actuator
	old: optimal_max_force = 250
	new: optimal_max_force = 350
	result: CMC finished up to a time of 0.75 seconds
	notes: muscle activations are smol, at most 0.0240 (and the minimum allowable value is 0.02)
	thoughts: crank_angle_actuator is too strong and doing all of the work?