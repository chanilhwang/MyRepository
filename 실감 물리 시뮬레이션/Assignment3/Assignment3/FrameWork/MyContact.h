#pragma once


#include <vector>
#include "particle.h"
#include "plinks.h"


namespace cyclone {

	class MyGroundContact : public cyclone::ParticleContactGenerator
	{
		std::vector<cyclone::Particle *> particles;
		double size;
	public:
		MyGroundContact();
		~MyGroundContact();
		void init(cyclone::Particle * p, double size);

		virtual unsigned addContact(cyclone::ParticleContact *contact, unsigned limit) const;
	};

	class ParticleCollision : public cyclone::ParticleLink
	{
		double size;
	public:
		ParticleCollision(double size);
		~ParticleCollision();
		virtual unsigned addContact(ParticleContact* contact,
			unsigned limit) const;
	};
}