FactoryBot.define do
  factory :component do
    value '220pF'
    marking '221J'
    description 'C0G Ceramic Capacitor'
    mfr 'Kemet'
    vendor 'Digi-Key'
    sequence(:mfr_part_number) {|n| "C315C221J1G5TA#{n}"}
    sequence(:vendor_part_number) {|n| "399-416#{n}-ND"}
    stock 10
    lead_time 1

    trait :constant do
      value '220pF'
      marking '221J'
      description 'C0G Ceramic Capacitor'
      mfr 'Kemet'
      vendor 'Digi-Key'
      mfr_part_number 'C315C221J1G5TA'
      vendor_part_number '399-4160-ND'
      stock 10
      lead_time 1
    end

    factory :constant_component, traits: [:constant]

  end

end
