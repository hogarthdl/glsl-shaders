displacement
ovalnoised( float
            Ar = 0.05,              // u diameter
            Br = 0.10,              // v diameter
            NoiseAmp = 0.00,        // noise amplitude
            DispAmp = 0.20;          // displacement amplitude
			color specularColor = color( 1, 1, 1 )
)
{
		point PP = point "shader" P;  //cast? 
		float magnitude = 0.;
		float size = 1.4;
		float i;
		for(i = 0.; i < 6.0; i += 1.0)
		{
				magnitude += (noise(size * PP) - 0.5) / size;
				size *= 2.0;
		}

		float up = 2. * u;      // because we are rendering a sphere
		float vp = v;
		float numinu = floor( up / (2.*Ar) ); //floor returns the largest integer 
		float numinv = floor( vp / (2.*Br) ); 
		//color dotColor = Cs;
		
							   
		float uc = numinu *2.* Ar + Ar;
		float vc = numinv *2.* Br + Br;
		float du = up - uc;
		float dv = vp - vc;
			
		float oldrad = sqrt( du*du + dv*dv);
		float newrad = oldrad + magnitude;
		float factor = newrad / oldrad;
		
		du *= factor;
		dv *= factor;

        float d = ( du * du ) / (Ar * Ar) + ( dv * dv ) / (Br * Br); //?????
		
		
        float disp =  1. - d ; //?????;
		if( disp > 0. )
		{
			normal n = normalize(N);
			N = calculatenormal(P + disp * DispAmp * n);
			//P = P + disp * DispAmp * n;
			//N = calculatenormal(P);
		}
}