%% Phase unwrapping via hierarchical and balanced residue partitioning
%
% Please cite the article below
% Deprem, Z., Onat, E. Phase unwrapping via hierarchical and balanced residue partitioning. Signal, Image and Video Processing, 18, 2895–2902 (2024). https://doi.org/10.1007/s11760-023-02958-5
%
%
% Dr. Zeynel Deprem
% Dr. Emrah Onat (eonat87@yahoo.com)
% 

%%

function mask=Local_Branch_Cut(r,win)
	[M,N]=size(r);mask=zeros(M,N);

	%local processing with window size=1;
	w=win;
	[I,J]=find(r);L=length(I);
	for k=1:L
		i=I(k);j=J(k);
		rngy=max(1,i-w):min(M,i+w);rngx=max(1,j-w):min(N,j+w);% range indexes for surrounding -w/+w box 
		mbox=mask(rngy,rngx);%select mask region (box) surrounding the current selected rsidue 
		rbox=r(rngy,rngx); %select residues surrounding the current selected rsidue  
		idxpos=find(rbox==1 & mbox==0);npos=length(idxpos); % index of unprocessed positive residues in selected box
		idxneg=find(rbox==-1 & mbox==0);nneg=length(idxneg);% index of unprocessed negative residues in selected box
		npair=min(npos,nneg); % number of avaialble balanced pairs selected box
		mbox(idxpos(1:npair))=1;% mark the balanced positive residues
		mbox(idxneg(1:npair))=1;% mark the balanced negative residues
		mask(rngy,rngx)=max(mask(rngy,rngx),mbox); % merge the mbox with exisiting mask (OR operation)
	end

	%imagesc(r.*(1-mask));title(['remaining res. after w=1: norm = ' num2str(sum(sum(abs(r.*(1-mask)))))]);figure

	%{
	for w=2:2
	[I,J]=find(r);L=length(I);
	for k=1:L
		i=I(k);j=J(k);
		rngy=max(1,i-w):min(M,i+w);rngx=max(1,j-w):min(N,j+w);% range indexes for surrounding -w/+w box 
		mbox=mask(rngy,rngx);%select mask region (box) surrounding the current selected rsidue 
		rbox=r(rngy,rngx); %select residues surrounding the current selected rsidue  
		idxpos=find(rbox==1 & mbox==0);npos=length(idxpos); % index of unprocessed positive residues in selected box
		idxneg=find(rbox==-1 & mbox==0);nneg=length(idxneg);% index of unprocessed negative residues in selected box
		npair=min(npos,nneg); % number of avaialble balanced pairs selected box
		mbox=mbox*0;
		if(npair)
		mbox(idxpos(1:npair))=1;% mark the balanced positive residues
		mbox(idxneg(1:npair))=-1;% mark the balanced negative residues
		mbox=BestOf4Scan(mbox);
		end
		mask(rngy,rngx)=max(mask(rngy,rngx),mbox); % merge the mbox with exisiting mask (OR operation)
	end
	end
	%}


	%local processing with window size=2;
	w=2;
	[I,J]=find(r & mask==0);L=length(I);% select the remaining unprocessed residues;
	for k=1:L
		i=I(k);j=J(k);
		if (~mask(i,j)) % just use unprocessed residues. The residue may have been processed in previous steps
		rngy=max(1,i-w):min(M,i+w);rngx=max(1,j-w):min(N,j+w);% range indexes for surrounding -w/+w box 
		mbox=mask(rngy,rngx); % select mask region (box) surrounding the current selected rsidue 
		rbox=r(rngy,rngx); % select residues surrounding the current selected rsidue  
		[Ib,Jb]=find(rbox==-r(i,j) & mbox==0); %find the indexes of oposite polarity and unprocessed residues in selected box.

	%   subplot(221);imagesc(rbox);title(['rbox global  i,j = ' num2str(i) '  ' num2str(j)]);
	%   subplot(222);imagesc(mbox);title('mbox');
	%   subplot(223);imagesc(rbox==-r(i,j) & mbox==0);title('rbox =-r(i,j) & mbox==0');    
		
			if ( ~isempty(Ib)) % if the box has at least one oposite polarity residue to be paired               
			[m,n]=size(mbox);
			mbox=zeros(m,n);%clear mbo
			ic=min(w+1,i);jc=min(w+1,j);% relative position of i,j in selected mbox (border point are also considered)
			mbox=connect_points([ic jc],[Ib(1) Jb(1)],mbox);%connect the current residue with the first candidate.        
			mask(rngy,rngx)=max(mask(rngy,rngx),mbox); % merge the mbox with exisiting mask (OR operation)
			end  
		%subplot(224);imagesc(mbox);pause
		end 
	end

	%imagesc(r.*(1-mask));title(['remaining res after w1,w2 : norm = ' num2str(sum(sum(abs(r.*(1-mask)))))]);figure

	% The following part connects the residues which are not paired and are
	% close to the border to the border. 
	% This section also tries to leave a balanced residue (if possible)


	dmax=min(round(N/16),round(M/16));
	rem_bal=1;d=1;
	while (rem_bal && d<dmax)
	[dmax d];
	bmask=mask;bmask(d+1:M-d,d+1:N-d)=1;
	[I,J]=find(r & bmask==0);L=length(I);% select the remaining unprocessed residues;

	for k=1:L
		i=I(k);j=J(k);
		b=[i-1 M-i j-1 N-j];[v idx]=min(b);
		if (~mask(i,j))
			switch idx
				case 1
				mask=connect_points([i j], [1 j],mask);
				case 2
				mask=connect_points([i j], [M j],mask);
				case 3
				mask=connect_points([i j], [i 1],mask);
				case 4   
				mask=connect_points([i j], [i N],mask);
			end 
		end
	end
	rem_bal=sum(sum(r.*(1-mask)));
	d=d+1;
	end

end
