%
% phantom detector
%
function ph = detect_phantom(time, vals_busy, vals_rx)

	ub = 0.98;
	ep = 0.01;

	ph = [];

	% Phantom mode indicates whether we are currently 'recording' a
	% phantom pkt
	pmode = 0;

	% Drop mode indicates how we handle drops of busy/rx below epsilon.
	% If drop mode is on, we ignore those drops. If it's off we are
	% basically just waiting for the next drop of busy/rx below eps. to
	% push our currently recorded phantom pkt.
	dmode = 0;

	% indicates after how much consecutive aci samples we turn of dmode
	% i.a.w.: if this max. is reached the next drop < eps pushes the
	% current phantom pkt.
	pmode_max = 10;

	% indicates after how much consecutive samples below epsilon we stop
	% recording our phantom pkt. I.a.w.: if this max. is reached, we go
	% back in time to when we incremented dmode_cnt for the first time
	% and push the phantom pkt at this point in time. Then we continue
	% from there, as if nothing has happened.
	dmode_max = 10;

	pmode_cnt = 0;
	dmode_cnt = 0;

	% holds the point in time where we incremented dmode_cnt for the first
	% time since this is a possible end point of a phantom pkt.
	dmode_rewind = 0;

	% start and stop times of the current phantom pkt.
	start = 0;
	stop  = 0;


	for ii=1:size(vals_busy,1)
		valb = vals_busy(ii);
		valr = vals_rx(ii);

		aci     = (valb <= ub) && (valb >= ep) && (valr <= ep);
		rx      = (valb >= ub) && (valr >= ub);
		silence = (valb <= ep) && (valr <= ep);


		% ACI start
		if (pmode == 0 && dmode == 0 && aci)
			start = ii;

			pmode = 1;
			dmode = 1;

			pmode_cnt = pmode_cnt + 1;
		end


		% silence: snap out of phantom mode and reset
		if (pmode == 1 && dmode == 0 && silence)
			stop = ii;
			ph = [ph; [start stop time(start) time(stop)]];

			pmode_cnt = 0;
			dmode_cnt = 0;

			pmode = 0;
			dmode = 0;
		end


		% rx capture: snap out of phantom mode and reset
		if (pmode == 1 && dmode == 0 && rx)
		ph = [ph; [start stop time(start) time(stop)]];	stop = ii;
			ph = [ph; [start stop time(start) time(stop)]];

			pmode_cnt = 0;
			dmode_cnt = 0;

			pmode = 0;
			dmode = 0;
		end


		% rx capture: snap out of phantom mode and reset
		if (pmode == 1 && dmode == 1 && rx)
			stop = ii;
			ph = [ph; [start stop time(start) time(stop)]];

			pmode_cnt = 0;
			dmode_cnt = 0;

			pmode = 0;
			dmode = 0;
		end


		% ACI cont'd
		if (pmode == 1 && dmode == 1 && aci)
			if (pmode_cnt >= pmode_max)
				dmode = 0;
			else
				pmode_cnt = pmode_cnt + 1;
			end

			% if this is a peak in a CRC pkt
			if (dmode_cnt > 0)
				dmode_cnt = 0;
			end

		end


		% drop during pmode when still in dmode, could indicate
		% trailing CRC
		if (pmode == 1 && dmode == 1 && silence)

			% at the end of trailing CRC: snap out of pmode and reset
			if (dmode_cnt >= dmode_max)
				% rewind to where the trailing CRC pkt really ended and
				% continue from there
				ii = dmode_rewind;

				stop = ii;
				ph = [ph; [start stop time(start) time(stop)]];

				pmode_cnt = 0;
				dmode_cnt = 0;

				pmode = 0;
				dmode = 0;

				dmode_rewind = 0;

			% still in phan. pkt: ignore drops by resetting dmode cnt
			else
				% remember the first drop as a possible end
				% point of the current phantom pkt.
				if (dmode_cnt == 0)
					dmode_rewind = ii;
				end

				dmode_cnt = dmode_cnt + 1;
				pmode_cnt = 0;
			end

		end



	end

end
