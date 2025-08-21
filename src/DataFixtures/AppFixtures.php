<?php

namespace App\DataFixtures;

use App\Entity\Role;
use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class AppFixtures extends Fixture
{
    public function __construct(
        private UserPasswordHasherInterface $passwordHasher
    ) {}

    public function load(ObjectManager $manager): void
    {
        // Créer les rôles
        $roles = [
            'ROLE_USER' => 'Utilisateur standard',
            'ROLE_ADMIN' => 'Administrateur',
            'ROLE_MODERATOR' => 'Modérateur',
            'ROLE_EDITOR' => 'Éditeur'
        ];

        $roleEntities = [];
        foreach ($roles as $label => $description) {
            $role = new Role();
            $role->setLabel($label);
            $role->setDescription($description);
            $role->setIsActive(true);
            $manager->persist($role);
            $roleEntities[$label] = $role;
        }

        // Créer un utilisateur admin
        $adminUser = new User();
        $adminUser->setEmail('admin@example.com');
        $adminUser->setFirstName('Admin');
        $adminUser->setLastName('User');
        $adminUser->setPhone('+33123456789');
        $adminUser->setIsActive(true);
        $adminUser->setRoles(['ROLE_ADMIN']);
        
        // Hasher le mot de passe
        $hashedPassword = $this->passwordHasher->hashPassword($adminUser, 'admin123');
        $adminUser->setPassword($hashedPassword);
        
        // Assigner les rôles
        $adminUser->addUserRole($roleEntities['ROLE_USER']);
        $adminUser->addUserRole($roleEntities['ROLE_ADMIN']);
        
        $manager->persist($adminUser);

        // Créer un utilisateur standard
        $user = new User();
        $user->setEmail('user@example.com');
        $user->setFirstName('John');
        $user->setLastName('Doe');
        $user->setPhone('+33987654321');
        $user->setIsActive(true);
        $user->setRoles(['ROLE_USER']);
        
        // Hasher le mot de passe
        $hashedPassword = $this->passwordHasher->hashPassword($user, 'user123');
        $user->setPassword($hashedPassword);
        
        // Assigner le rôle utilisateur
        $user->addUserRole($roleEntities['ROLE_USER']);
        
        $manager->persist($user);

        $manager->flush();
    }
}
