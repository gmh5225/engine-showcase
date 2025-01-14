/*!
*  @company Black Art Studios
*  @author Nicholas Kostelnik
*  @file   MathVector3.hpp
*  @date   2009/04/26
*/
#ifndef MATHVECTOR3_H
#define MATHVECTOR3_H

#include <OgreVector3.h>
#include <Common/Base/hkBase.h>
#include <fmod.hpp>

#include "MathUnits.hpp"
#include "MathMatrix.h"

namespace Maths
{
	/*! 
	 *  A Representation of a 3 Dimensional Maths Vector
	 */
	class MathVector3
	{

	public:

		typedef std::deque< MathVector3 > MathVector3List;

		float X, Y, Z;

		/*! Default Constructor, returns a Zero Vector
		 *
		 *  @return ()
		 */
		MathVector3( )
			: X( 0 )
			, Y( 0 )
			, Z( 0 )
		{

		}


		/*! Constructs from input values
		 *
		 *  @param[in] float x
		 *  @param[in] float y
		 *  @param[in] float z
		 *  @return ()
		 */
		MathVector3( const float& x, const float& y, const float& z )
			: X( x )
			, Y( y )
			, Z( z )
		{

		}


		/*! Constructs from Ogre's representation of a 3 dimensional vector for convenience and speed!
		 *
		 *  @param[in] Ogre::Vector3 vector
		 *  @return ()
		 */
		MathVector3( const Ogre::Vector3& vector )
			: X( vector.x )
			, Y( vector.y )
			, Z( vector.z )
		{

		}


		/*! Constructs from Havok's representation of a 3 dimensional vector for convenience and speed!
		 *
		 *  @param[in] const hkVector4 & vector
		 *  @return ()
		 */
		MathVector3( const hkVector4& vector )
			: X( vector( 0 ) )
			, Y( vector( 1 ) )
			, Z( vector( 2 ) )
		{

		}


		/*! Returns Ogre's representation of a 3 dimensional Vector for convenience
		 *
		 *  @return (Ogre::Vector3)
		 */
		inline Ogre::Vector3 AsOgreVector3( ) const { return Ogre::Vector3( X, Y, Z ); };

		
		/*! Returns Havok's representation of a 3 dimensional Vector for convenience
		 *
		 *  @return (hkVector4)
		 */
		inline hkVector4 AshkVector4( ) const { return hkVector4( X, Y, Z ); };

		/*! Returns FMOD's representation of a 3 dimensional Vector for convenience
		 *
		 *  @return (FMOD_VECTOR)
		 */
		inline FMOD_VECTOR AsFMODVector( ) const { FMOD_VECTOR returnValue; returnValue.x = X; returnValue.y = Y; returnValue.z = Z; return returnValue; };


		/*! Returns the Dot Product of the Vector and the specified input
		 *
		 *  @param[in] const MathVector3 & input
		 *  @return (float)
		 */
		inline float DotProduct( const MathVector3& input ) const
		{
			return X * input.X + Y * input.Y + Z * input.Z;
		}

		
		/*! Returns the length of the Vector
		 *
		 *  @return (float)
		 */
		inline float Length( ) const
		{
			return sqrt( X * X + Y * Y + Z * Z );
		}


		/*! Returns the Cross Product of the Vector and the specified input
		 *
		 *  @param[in] const MathVector3 & input
		 *  @return (Maths::MathVector3)
		 */
		inline MathVector3 CrossProduct( const MathVector3& input ) const
		{
			return MathVector3(
				Y * input.Z - Z * input.Y,
				Z * input.X - X * input.Z,
				X * input.Y - Y * input.X
				);
		}


		/*! Returns a Normalized version of the Vector
		 *
		 *  @return (Maths::MathVector3)
		 */
		inline MathVector3 Normalize( ) const
		{
			float length = sqrt( X * X + Y * Y + Z * Z  );

			return ( length > 0.0f ) 
				? MathVector3( X, Y, Z ) / length
				: MathVector3( X, Y, Z );
		}


		/*! Rounds the Vector Values to the nearest whole number
		*
		* @return ( Maths::MathVector3 )
		*/
		inline MathVector3 Round( ) const
		{
			return MathVector3(
				MathUnits::Round( X ),
				MathUnits::Round( Y ),
				MathUnits::Round( Z )
				);
		}


		/*! Divides the Vector by the specified input
		 *
		 *  @param[in] const float & input
		 *  @return (Maths::MathVector3)
		 */
		inline MathVector3 operator / ( const float& input ) const
		{
			return MathVector3(
				X / input,
				Y / input,
				Z / input
				);
		}


		/*! Returns a version of the Vector that has been added to the input
		 *
		 *  @param[in] const MathVector3 & input
		 *  @return (Maths::MathVector3)
		 */
		inline MathVector3 operator + ( const MathVector3& input ) const
		{
			return MathVector3(
				input.X + X,
				input.Y + Y,
				input.Z + Z
				);
		};


		/*! Returns a version of the Vector that has been added to the input
		 *
		 *  @param[in] const MathVector3 & input
		 *  @return (Maths::MathVector3)
		 */
		inline MathVector3 operator += ( const MathVector3& input ) const
		{
			return *this + input;
		};


		/*! Returns a version of the Vector that has been subtracted from the input
		 *
		 *  @param[in] const MathVector3 & input
		 *  @return (Maths::MathVector3)
		 */
		inline MathVector3 operator - ( const MathVector3& input ) const
		{
			return MathVector3(
				X - input.X,
				Y - input.Y,
				Z - input.Z
				);
		};


		/*! Returns a version of the Vector that has been multiplied by the input scalar
		 *
		 *  @param[in] const float & input
		 *  @return (Maths::MathVector3)
		 */
		inline MathVector3 operator * ( const float& input ) const
		{
			return MathVector3(
				input * X,
				input * Y,
				input * Z
				);
		};


		/*! Returns a version of the Vector that has been multiplied by the input Vector
		 *
		 *  @param[in] const MathVector3 & input
		 *  @return (Maths::MathVector3)
		 */
		inline MathVector3 operator * ( const MathVector3& input ) const
		{
			return MathVector3(
				X * input.X,
				Y * input.Y,
				Z * input.Z
				);
		};


		/*! Returns whether the vector values match the input vector values
		*
		* @param[in] const MathVector3 & input
		* @return ( bool )
		*/
		inline bool operator == ( const MathVector3& input ) const
		{
			return (
				X == input.X && 
				Y == input.Y &&
				Z == input.Z );
		}


		/*! Returns whether the vector values do not match the input vector values
		*
		* @param[in] const MathVector3 & input
		* @return ( bool )
		*/
		inline bool operator != ( const MathVector3& input ) const
		{
			return !( * this == input );
		}


		/*! Returns a version of the Vector that has been multiplied by the input Matrix
		 *
		 *  @param[in] const MathMatrix & input
		 *  @return (Maths::MathVector3)
		 */
		inline MathVector3 operator * ( const MathMatrix& input ) const
		{
			return this->AsOgreVector3( ) * input;
		}


		/*! Returns a Vector pointing UP
		 *
		 *  @return (Maths::MathVector3)
		 */
		static inline MathVector3 Up( ) { return MathVector3( 0.0f, 1.0f, 0.0f ); };


		/*! Returns a Vector pointing FORWARD
		 *
		 *  @return (Maths::MathVector3)
		 */
		static inline MathVector3 Forward( ) { return MathVector3( 0.0f, 0.0f, -1.0f ); };


		/*! Returns a Zero Vector
		 *
		 *  @return (Maths::MathVector3)
		 */
		static inline MathVector3 Zero( ) { return MathVector3( 0.0f, 0.0f, 0.0f ); };

	};
};

#endif