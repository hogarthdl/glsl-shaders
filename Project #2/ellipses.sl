surface
ellipses( float
		Ar = 0.05,
		Br = 0.10,
		Ks = 0.5,    // In addition to color controls, we want to add scale values for our diffuse, specular, 
		Kd = 0.5,    // and ambient lighting contributions. By convention, these are written as Kd, Ks, and Ka, respectively
		Ka = .1,
		roughness = 0.1,
		NoiseAmp = 0.00,        // noise amplitude
        DispAmp = 0.10;          // displacement amplitude
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
		color dotColor = Cs;
		
							   
		float uc = numinu *2.* Ar + Ar;
		float vc = numinv *2.* Br + Br;
		float du = up - uc;
		float dv = vp - vc;
			
		float oldrad = sqrt( du*du + dv*dv);
		float newrad = oldrad + magnitude;
		float factor = newrad / oldrad;
		
		du *= factor;
		dv *= factor;

		float d = ( du * du ) / (Ar * Ar) + ( dv * dv ) / (Br * Br);
		
		if( d <= 1. )
		{
			dotColor = color( 1.5, 1.0, 0.5 ); 
		}
		
		
			
		varying vector Nf = faceforward( normalize( N ), I );
		vector V = normalize( -I );
		Oi = 1.;
		Ci = Oi * ( dotColor * ( Ka * ambient() + Kd * diffuse(Nf) ) +
				specularColor * Ks * specular( Nf, V, roughness ) );
}