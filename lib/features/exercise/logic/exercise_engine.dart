// lib/features/exercise/logic/exercise_engine.dart

import '../domain/models/exercise_model.dart';

/// Exercise recommendation engine
///
/// Generates personalized exercise programs based on assessment level
/// Following French medical rehabilitation protocols (post-AVC)
///
/// videoUrl conventions:
///   'assets/...'   → local asset (GIF or MP4)
///   'yt:VIDEO_ID'  → YouTube video (extracted from full URL)
///   ''             → no video, show placeholder
class ExerciseEngine {
  static ExerciseRecommendationSet getRecommendations(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return _getLevel1Exercises();
      case 2:
        return _getLevel2Exercises();
      case 3:
        return _getLevel3Exercises();
      default:
        return _getLevel3Exercises();
    }
  }

  // ---------------------------------------------------------------------------
  // NIVEAU 1 — CRITIQUE
  // ---------------------------------------------------------------------------
  static ExerciseRecommendationSet _getLevel1Exercises() {
    return ExerciseRecommendationSet(
      levelNumber: 1,
      title: 'Programme de Réadaptation - Niveau Critique',
      description:
          'Ces exercices doivent être réalisés sous supervision médicale. '
          'Commencez lentement et arrêtez si vous ressentez de la douleur ou du malaise.',
      weeklyGoal: '5-7 jours par semaine, en sessions courtes (10-15 minutes)',
      exercises: [
        ExerciseModel(
          id: 'l1_breathing',
          name: 'Exercices de Respiration Profonde',
          description:
              'Inspirez lentement par le nez pendant 4 secondes, retenez 2 secondes, '
              'expirez par la bouche pendant 4 secondes.',
          category: ExerciseCategory.endurance,
          difficulty: ExerciseDifficulty.easy,
          duration: 5,
          repetitions: 10,
          frequency: '3 fois par jour',
          precautions: [
            'Arrêtez si vous vous sentez étourdi',
            'Respirez naturellement entre les séries',
            'Ne forcez pas',
          ],
          benefits: [
            'Réduit l\'anxiété et le stress',
            'Améliore l\'oxygénation',
            'Prépare le corps à l\'exercice',
          ],
          imageUrl: 'assets/exercises/breathing.png',
          videoUrl: 'yt:CZ1YAveWxH0',
          gifUrl: '',
          videoDuration: 180,
        ),
        ExerciseModel(
          id: 'l1_bed_mobility',
          name: 'Mobilité au Lit',
          description:
              'En position allongée, bougez vos bras et jambes lentement. '
              'Pliez les genoux, soulevez les bras. Essayez de vous asseoir progressivement avec aide.',
          category: ExerciseCategory.mobility,
          difficulty: ExerciseDifficulty.easy,
          duration: 10,
          repetitions: 5,
          frequency: '3-4 fois par jour',
          precautions: [
            'Ayez toujours de l\'aide à proximité',
            'Utilisez les barres du lit',
            'Allez lentement',
            'Évitez les mouvements brusques',
          ],
          benefits: [
            'Prévient les contractures',
            'Stimule la circulation',
            'Maintient la mobilité articulaire',
          ],
          imageUrl: 'assets/exercises/bed_mobility.png',
          videoUrl: 'yt:BF9IWcQkdQk',
          gifUrl: 'assets/exercises/bed_mobility_exercise_loop.gif',
          videoDuration: 240,
        ),
        ExerciseModel(
          id: 'l1_ankle_circles',
          name: 'Rotations des Chevilles',
          description:
              'Assis confortablement, levez une jambe légèrement et faites des cercles '
              'avec votre pied. D\'abord dans un sens, puis dans l\'autre.',
          category: ExerciseCategory.mobility,
          difficulty: ExerciseDifficulty.easy,
          duration: 5,
          repetitions: 10,
          frequency: '2 fois par jour',
          precautions: [
            'Bougez lentement et contrôlé',
            'Pas de douleur',
          ],
          benefits: [
            'Améliore la mobilité des chevilles',
            'Prévient la thrombose',
            'Augmente la circulation',
          ],
          imageUrl: 'assets/exercises/ankle_circles.png',
          videoUrl: 'yt:M4JN2yZxC_o',
          gifUrl: 'assets/exercises/ankle_circle_rotation.gif',
          videoDuration: 150,
        ),
        ExerciseModel(
          id: 'l1_seated_marching',
          name: 'Marche Assise',
          description:
              'Assis sur une chaise stable, levez alternativement vos genoux comme si vous marchiez. '
              'Gardez le dos droit, les mains sur la chaise.',
          category: ExerciseCategory.endurance,
          difficulty: ExerciseDifficulty.easy,
          duration: 10,
          repetitions: 30,
          frequency: '2 fois par jour',
          precautions: [
            'Chaise stable',
            'Mains disponibles pour vous tenir',
            'Rythme lent et régulier',
          ],
          benefits: [
            'Améliore l\'endurance',
            'Renforce les jambes progressivement',
            'Prépare à la marche',
          ],
          imageUrl: 'assets/exercises/seated_marching.png',
          videoUrl: 'yt:VjM4b2KUehs',
          gifUrl: 'assets/exercises/seated_marching.gif',
          videoDuration: 300,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // NIVEAU 2 — MODÉRÉ
  // ---------------------------------------------------------------------------
  static ExerciseRecommendationSet _getLevel2Exercises() {
    return ExerciseRecommendationSet(
      levelNumber: 2,
      title: 'Programme de Réadaptation - Niveau Modéré',
      description:
          'Ces exercices nécessitent toujours une supervision ou l\'aide d\'une personne. '
          'Vous pouvez progressivement augmenter la difficulté.',
      weeklyGoal: '5-7 jours par semaine, sessions de 20-30 minutes',
      exercises: [
        ExerciseModel(
          id: 'l2_sit_to_stand',
          name: 'Lever de la Chaise (Assis-Debout)',
          description:
              'Assis sur une chaise ferme, pieds à plat au sol. Penchez-vous en avant légèrement '
              'et levez-vous en gardant le dos droit. Utilisez les accoudoirs si nécessaire.',
          category: ExerciseCategory.strength,
          difficulty: ExerciseDifficulty.moderate,
          duration: 10,
          repetitions: 8,
          frequency: '1-2 fois par jour',
          precautions: [
            'Chaise stable et ferme',
            'Quelqu\'un à proximité',
            'Allez lentement',
            'Si vous ne pouvez pas vous lever seul, demandez de l\'aide',
          ],
          benefits: [
            'Renforce les jambes',
            'Améliore l\'équilibre',
            'Prépare à la marche indépendante',
          ],
          imageUrl: 'assets/exercises/sit_to_stand.png',
          videoUrl: 'yt:cUz_TSy7_fw',
          gifUrl: 'assets/exercises/sit_to_stand.gif',
          videoDuration: 60,
        ),
        ExerciseModel(
          id: 'l2_standing_balance',
          name: 'Équilibre en Position Debout',
          description:
              'Tenez-vous debout près d\'un meuble stable. Tenez le meuble avec une main. '
              'Essayez de relâcher progressivement votre prise (10 secondes) puis tenez à nouveau.',
          category: ExerciseCategory.balance,
          difficulty: ExerciseDifficulty.moderate,
          duration: 10,
          repetitions: 5,
          frequency: '2 fois par jour',
          precautions: [
            'Support stable à proximité',
            'Quelqu\'un doit être présent',
            'Portez des chaussures appropriées',
            'Arrêtez si vous vous sentez instable',
          ],
          benefits: [
            'Améliore l\'équilibre',
            'Renforce les muscles stabilisateurs',
            'Augmente la confiance en debout',
          ],
          imageUrl: 'assets/exercises/standing_balance.png',
          videoUrl: 'yt:QbonJhksiGg',
          gifUrl: 'assets/exercises/stick_balance_loop.gif',
          videoDuration: 210,
        ),
        ExerciseModel(
          id: 'l2_walking_aid',
          name: 'Marche avec Déambulateur ou Canne',
          description:
              'Avec un déambulateur ou une canne (selon les recommandations), '
              'marchez lentement à un rythme confortable. Regardez devant vous.',
          category: ExerciseCategory.endurance,
          difficulty: ExerciseDifficulty.moderate,
          duration: 15,
          repetitions: 1,
          frequency: '2-3 fois par jour',
          precautions: [
            'Utilisez l\'aide appropriée (canne, déambulateur)',
            'Surface plane et sûre',
            'Supervision recommandée',
            'Chaussures stables',
          ],
          benefits: [
            'Améliore l\'endurance à la marche',
            'Renforce les jambes',
            'Augmente la mobilité',
          ],
          imageUrl: 'assets/exercises/walking_aid.png',
          videoUrl: 'yt:ff6KlUGlQ3E',
          gifUrl: 'assets/exercises/walker_stick_figure_loop.gif',
          videoDuration: 270,
        ),
        ExerciseModel(
          id: 'l2_leg_lifts',
          name: 'Levées de Jambe',
          description:
              'Assis ou allongé, levez une jambe droite à la hauteur du genou, '
              'maintenez 2 secondes, puis baissez. Alternez les deux jambes.',
          category: ExerciseCategory.strength,
          difficulty: ExerciseDifficulty.moderate,
          duration: 10,
          repetitions: 10,
          frequency: '2 fois par jour',
          precautions: [
            'Mouvements contrôlés',
            'Pas de douleur',
          ],
          benefits: [
            'Renforce les muscles des jambes',
            'Améliore la stabilité',
          ],
          imageUrl: 'assets/exercises/leg_lifts.png',
          videoUrl: 'yt:H4n9mCMgmNY',
          gifUrl: 'assets/exercises/seated_leg_raise_loop.gif',
          videoDuration: 180,
        ),
        ExerciseModel(
          id: 'l2_stretching',
          name: 'Étirements Légers',
          description:
              'Étirez doucement les mollets, quadriceps et ischio-jambiers. '
              'Maintenez chaque étirement 15-20 secondes.',
          category: ExerciseCategory.flexibility,
          difficulty: ExerciseDifficulty.easy,
          duration: 10,
          repetitions: 1,
          frequency: '1 fois par jour',
          precautions: [
            'Ne forcez pas',
            'Arrêtez si douleur',
            'Respiration normale',
          ],
          benefits: [
            'Améliore la flexibilité',
            'Réduit la raideur',
            'Aide à la récupération',
          ],
          imageUrl: 'assets/exercises/stretching.png',
          videoUrl: 'yt:kv4rgI2D464',
          gifUrl: 'assets/exercises/standing_stretch_loop.gif',
          videoDuration: 240,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // NIVEAU 3 — BON
  // ---------------------------------------------------------------------------
  static ExerciseRecommendationSet _getLevel3Exercises() {
    return ExerciseRecommendationSet(
      levelNumber: 3,
      title: 'Programme de Maintien et Prévention',
      description:
          'Ces exercices visent à maintenir et améliorer votre fonctionnalité. '
          'Vous êtes capable de les faire avec peu ou pas de supervision.',
      weeklyGoal: '5-7 jours par semaine, sessions de 30-45 minutes',
      exercises: [
        ExerciseModel(
          id: 'l3_walking',
          name: 'Marche Indépendante',
          description:
              'Marchez à un rythme confortable sans aide, 15-30 minutes. '
              'Variez le terrain (plat, légère pente).',
          category: ExerciseCategory.endurance,
          difficulty: ExerciseDifficulty.moderate,
          duration: 30,
          repetitions: 1,
          frequency: 'Tous les jours ou presque',
          precautions: [
            'Terrain sûr',
            'Chaussures stables',
            'Hydratez-vous',
          ],
          benefits: [
            'Cardio-vasculaire',
            'Endurance générale',
            'Santé mentale',
          ],
          imageUrl: 'assets/exercises/walking.png',
          videoUrl: 'yt:16oJspYFz7s',
          gifUrl: 'assets/exercises/stick_figure_walking_cycle.gif',
          videoDuration: 300,
        ),
        ExerciseModel(
          id: 'l3_balance_advanced',
          name: 'Exercices d\'Équilibre Avancé',
          description:
              'En position debout, levez une jambe légèrement en l\'air (30 secondes). '
              'Fermez les yeux progressivement pour augmenter la difficulté.',
          category: ExerciseCategory.balance,
          difficulty: ExerciseDifficulty.moderate,
          duration: 10,
          repetitions: 3,
          frequency: '3-4 fois par semaine',
          precautions: [
            'Support à proximité',
            'Surface plane',
          ],
          benefits: [
            'Équilibre avancé',
            'Prévention des chutes',
            'Confiance en soi',
          ],
          imageUrl: 'assets/exercises/balance_advanced.png',
          videoUrl: 'yt:kI-hbbuGvx0',
          gifUrl: 'assets/exercises/single_leg_balance_loop.gif',
          videoDuration: 220,
        ),
        ExerciseModel(
          id: 'l3_stairs',
          name: 'Montée et Descente d\'Escaliers',
          description:
              'Montez et descendez un escalier (ou marche) lentement et contrôlé. '
              'Une rampe à proximité est recommandée.',
          category: ExerciseCategory.strength,
          difficulty: ExerciseDifficulty.hard,
          duration: 10,
          repetitions: 2,
          frequency: '3-4 fois par semaine',
          precautions: [
            'Rampe disponible',
            'Chaussures stables',
            'Lentement et contrôlé',
          ],
          benefits: [
            'Force des jambes',
            'Endurance',
            'Fonction quotidienne',
          ],
          imageUrl: 'assets/exercises/stairs.png',
          videoUrl: 'yt:qpizu9NyMT4',
          gifUrl: 'assets/exercises/stair_climb_loop.gif',
          videoDuration: 180,
        ),
        ExerciseModel(
          id: 'l3_resistance',
          name: 'Exercices de Résistance Légère',
          description:
              'Utilisez des haltères légers (0.5-1 kg) pour renforcer les bras et les jambes. '
              '10 répétitions par exercice.',
          category: ExerciseCategory.strength,
          difficulty: ExerciseDifficulty.moderate,
          duration: 15,
          repetitions: 10,
          frequency: '3 fois par semaine',
          precautions: [
            'Poids légers au début',
            'Mouvements lents',
            'Respirez normalement',
          ],
          benefits: [
            'Force musculaire',
            'Métabolisme',
            'Densité osseuse',
          ],
          imageUrl: 'assets/exercises/resistance.png',
          videoUrl: 'yt:ieCntUnKWgw',
          gifUrl: '',
          videoDuration: 250,
        ),
        ExerciseModel(
          id: 'l3_yoga',
          name: 'Yoga/Tai Chi Léger',
          description:
              'Pratique douce combinant étirement, équilibre et respiration. '
              'Idéal pour la flexibilité et le bien-être.',
          category: ExerciseCategory.flexibility,
          difficulty: ExerciseDifficulty.easy,
          duration: 20,
          repetitions: 1,
          frequency: '2-3 fois par semaine',
          precautions: [
            'Salle avec espace',
            'Tapis de yoga',
            'Ne forcez pas',
          ],
          benefits: [
            'Flexibilité',
            'Équilibre',
            'Relaxation',
            'Bien-être mental',
          ],
          imageUrl: 'assets/exercises/yoga.png',
          videoUrl: 'yt:vsn1cHLAzjY',
          gifUrl: 'assets/exercises/tai_chi_knee_bend_loop.gif',
          videoDuration: 360,
        ),
      ],
    );
  }
}