function red = redQ_theta(theta,gs,geta,sGs,etaGeta,etaGs)

c = cos(theta); s = sin(theta);
red = -(c*gs + s*geta + 0.5*c^2*sGs + 0.5*s^2*etaGeta+ c*s*etaGs);


