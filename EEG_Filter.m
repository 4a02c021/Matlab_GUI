% pop_eegfiltnew() - Filter data using Hamming windowed sinc FIR filter
%
% Usage:
%   >> [EEG, com, b] = pop_eegfiltnew(EEG); % pop-up window mode
%   >> [EEG, com, b] = pop_eegfiltnew(EEG, locutoff, hicutoff, filtorder,
%                                     revfilt, usefft, plotfreqz, minphase);
%
% Inputs:
%   EEG       - EEGLAB EEG structure
%   locutoff  - lower edge of the frequency pass band (Hz)
%               {[]/0 -> lowpass} 
%   hicutoff  - higher edge of the frequency pass band (Hz)
%               {[]/0 -> highpass}
%
% Optional inputs:
%   filtorder - filter order (filter length - 1). Mandatory even
%   revfilt   - [0|1] invert filter (from bandpass to notch filter)
%               {default 0 (bandpass)}
%   usefft    - ignored (backward compatibility only)
%   plotfreqz - [0|1] plot filter's frequency and phase response
%               {default 0} 
%   minphase  - scalar boolean minimum-phase converted causal filter
%               {default false}
%
% Outputs:
%   EEG       - filtered EEGLAB EEG structure
%   com       - history string
%   b         - filter coefficients
%
% Note:
%   pop_eegfiltnew is intended as a replacement for the deprecated
%   pop_eegfilt function. Required filter order/transition band width is
%   estimated with the following heuristic in default mode: transition band
%   width is 25% of the lower passband edge, but not lower than 2 Hz, where
%   possible (for bandpass, highpass, and bandstop) and distance from
%   passband edge to critical frequency (DC, Nyquist) otherwise. Window
%   type is hardcoded to Hamming. Migration to windowed sinc FIR filters
%   (pop_firws) is recommended. pop_firws allows user defined window type
%   and estimation of filter order by user defined transition band width.
%
% Author: Andreas Widmann, University of Leipzig, 2012
%
% See also:
%   firfilt, firws, windows

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2008 Andreas Widmann, University of Leipzig, widmann@uni-leipzig.de
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function [EEG, com, b] = EEG_Filter(EEG,Fs,Point_per_trials,locutoff, hicutoff, filtorder, revfilt, usefft, plotfreqz, minphase)

% Constants
TRANSWIDTHRATIO = 0.25;
fNyquist = Fs / 2; % Fs/2

% Check arguments
if locutoff == 0, locutoff = []; end
if hicutoff == 0, hicutoff = []; end
if isempty(hicutoff) % Convert highpass to inverted lowpass
    hicutoff = locutoff;
    locutoff = [];
    revfilt = ~revfilt;
end
edgeArray = sort([locutoff hicutoff]);

% Max stop-band width
maxTBWArray = edgeArray; % Band-/highpass
if revfilt == 0 % Band-/lowpass
    maxTBWArray(end) = fNyquist - edgeArray(end);
elseif length(edgeArray) == 2 % Bandstop
    maxTBWArray = diff(edgeArray) / 2;
end
maxDf = min(maxTBWArray);

% Transition band width and filter order
    df = 3.3 / filtorder * Fs; % Hamming window
    filtorderMin = ceil(3.3 ./ ((maxDf * 2) / Fs) / 2) * 2;
    filtorderOpt = ceil(3.3 ./ (maxDf / Fs) / 2) * 2;
    if filtorder < filtorderMin
        error('Filter order too low. Minimum required filter order is %d. For better results a minimum filter order of %d is recommended.', filtorderMin, filtorderOpt)
    elseif filtorder < filtorderOpt
        warning('firfilt:filterOrderLow', 'Transition band is wider than maximum stop-band width. For better results a minimum filter order of %d is recommended. Reported might deviate from effective -6dB cutoff frequency.', filtorderOpt)
    end


filterTypeArray = {'lowpass', 'bandpass'; 'highpass', 'bandstop (notch)'};
% fprintf('pop_eegfiltnew() - performing %d point %s filtering.\n', filtorder + 1, filterTypeArray{revfilt + 1, length(edgeArray)})
% fprintf('pop_eegfiltnew() - transition band width: %.4g Hz\n', df)
% fprintf('pop_eegfiltnew() - passband edge(s): %s Hz\n', mat2str(edgeArray))

% Passband edge to cutoff (transition band center; -6 dB)
dfArray = {df, [-df, df]; -df, [df, -df]};
cutoffArray = edgeArray + dfArray{revfilt + 1, length(edgeArray)} / 2;
%fprintf('pop_eegfiltnew() - cutoff frequency(ies) (-6 dB): %s Hz\n', mat2str(cutoffArray))

% Window
winArray = windows('hamming', filtorder + 1);

% Filter coefficients
    b = firws(filtorder, cutoffArray / fNyquist, winArray);

% if minphase
%     disp('pop_eegfiltnew() - converting filter to minimum-phase (non-linear!)');
%     b = minphaserceps(b);
% end


% Filter
%    disp('pop_eegfiltnew() - filtering the data (zero-phase)');
    EEG = firfilt_revise(EEG, b,Point_per_trials);
% History string
%com = sprintf('%s = pop_eegfiltnew(%s, %s, %s, %s, %s, %s, %s);', inputname(1), inputname(1), mat2str(locutoff), mat2str(hicutoff), mat2str(filtorder), mat2str(revfilt), mat2str(usefft), mat2str(plotfreqz));

end
