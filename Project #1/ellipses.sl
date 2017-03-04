surface
ellipses( float
		Ar = 0.04,
		Br = 0.08,
		Ks = 0.5,    // In addition to color controls, we want to add scale values for our diffuse, specular, 
		Kd = 0.5,    // and ambient lighting contributions. By convention, these are written as Kd, Ks, and Ka, respectively
		Ka = .1,
		roughness = 0.1;
	  	color specularColor = color( 1, 1, 1 )
)
{
		float up = 2. * u;      // because we are rendering a sphere
		float vp = v;
		float numinu = floor( up / (2*Ar) ); //floor returns the largest integer ?
		float numinv = floor( vp / (2*Br) ); 
		color dotColor = Cs;
		if( mod( numinu+numinv, 2 ) == 0 ) 
		{								   
			float uc = numinu*2.*Ar + Ar;
			float vc = numinv*2.*Br + Br;
			float du = (up - uc)/Ar;
			float dv = (vp - vc)/Br;
			float d = du *du + dv*dv;
			if( d < 1 )
			{
				dotColor = color( 1.5, .5, 0.5 ); //red
			}
		}
		
		if( mod( numinu+numinv, 4 ) == 0 ) 
		{								   
			float uc = numinu*2.*Ar + Ar;
			float vc = numinv*2.*Br + Br;
			float du = (up - uc)/Ar;
			float dv = (vp - vc)/Br;
			float d = du *du + dv*dv;
			if( d < 1 )
			{
				dotColor = color( 1.5, 1, .5 ); // orange
			}
		}		
		
		
			
		varying vector Nf = faceforward( normalize( N ), I );
		vector V = normalize( -I );
		Oi = 1.;
		Ci = Oi * ( dotColor * ( Ka * ambient() + Kd * diffuse(Nf) ) +
				specularColor * Ks * specular( Nf, V, roughness ) );
}